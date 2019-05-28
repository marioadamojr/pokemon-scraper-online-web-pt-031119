class Pokemon
  attr_accessor :name, :type, :db, :hp
  attr_reader :id

  def initialize(id:, name:, type:, db:, hp: nil)
    @id=id
    @name=name
    @type=type
    @db=db
    @hp=hp
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?,?)
    SQL
    db.execute(sql, name, type)
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon") [0][0]
  end

  def self.find(id, db)
    sql = <<-SQL
      SELECT *
      FROM pokemon
      WHERE id = ?
    SQL
      # db.execute(sql, id).collect do |row|
      row = db.execute(sql, id)[0]
      # binding.pry
      # self.new(id:row[0], name:row[1], type:row[2], db:db)
      self.new(id:row[0], name:row[1], type:row[2], db:db, hp:row[3])
  end

  def alter_hp(new_hp, db)
    @hp = new_hp
    db.execute("UPDATE pokemon SET hp = ? WHERE id =?", new_hp, self.id)
    binding.pry
  end
end
