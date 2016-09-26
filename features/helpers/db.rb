require 'mysql'

class DB

  def self.id()
  mysql = Mysql.new("ec2-52-50-80-107.eu-west-1.compute.amazonaws.com", "devel", "admin4mysql", "clevergig_stage")

  res = mysql.query("SELECT id from users where email = 'clevergig@mail.ru';")
  company_id = res.fetch_row
=begin
  rows = res.num_rows
  rows.times do
    puts res.fetch_row.join("\s")
  end
  mysql.close
  end

  while res.next_result
    rs = mysql.store_result
    puts rs.fetch_row
  end

#get names of columns
  res.fetch_fields.each_with_index do |i|
    column = i.name
    end
=end
    mysql.close
  end

  def self.number_of_gigs(query)
    id = self.id()
    mysql = Mysql.new("ec2-52-50-80-107.eu-west-1.compute.amazonaws.com", "devel", "admin4mysql", "clevergig_stage")

    count = mysql.query("SELECT COUNT(*) from events where company_id='#{id}' and status='Pending';")

  end

end