require_relative '../../config/requirements'

And(/^API create following one day GIG:$/) do |table|
  role = table.rows_hash[:role]
  if role == "Bardienst"
    role = 3
  elsif role == "Bediening"
    role = 6
  end
  date = Time.now.strftime("%d/%m/%Y")
  if table.rows_hash[:date].to_s.include? '+'
    date = (Time.now + table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  elsif table.rows_hash[:date].to_s.include? '-'
    date = (Time.now - table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  end
  start_time = table.rows_hash[:'start time']
  end_time = table.rows_hash[:'end time']
  local_time = Time.now
  if table.rows_hash[:'start time'].to_s.include? 'round'
    if Time.now.min <= 30
      local_time = Time.now.change(:min => 0)
    else
      local_time = Time.now.change(:min => 0) + 3600
    end
  end
  if table.rows_hash[:'start time'].to_s.include? '+'
    start_time = (local_time + (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time + (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  elsif table.rows_hash[:'start time'].to_s.include? '-'
    start_time = (local_time - (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time - (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  end
  d = Date.parse(date)
  t_s = Time.parse(start_time)
  t_f = Time.parse(end_time)
  start = DateTime.new(d.year, d.month, d.day, t_s.hour, t_s.min, t_s.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  if t_s < t_f
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  else
    d = Date.parse(date) + 1
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  end
  desc = table.rows_hash[:description]
  v_desc = table.rows_hash[:'venue description']
  location = table.rows_hash[:location]
  number_of_workers = table.rows_hash[:'number of workers']
  API.create_gig(role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers)
  sleep(3)
end


Given(/^([^"]*) accept gig with ([^"]*) "([^"]*)"$/) do |any, any2, query|
  API.accept_gig(query)
end

Given(/^API creates promocode "([^"]*)"$/) do |arg|
  API.create_promocode(arg)
  @test_context[:promocode] = arg
end

And(/^API create following one day GIG with promo:$/) do |table|
  role = table.rows_hash[:role]
  if role == "Bardienst"
    role = 3
  elsif role == "Bediening"
    role = 6
  end
  date = Time.now.strftime("%d/%m/%Y")
  if table.rows_hash[:date].to_s.include? '+'
    date = (Time.now + table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  elsif table.rows_hash[:date].to_s.include? '-'
    date = (Time.now - table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  end
  start_time = table.rows_hash[:'start time']
  end_time = table.rows_hash[:'end time']
  local_time = Time.now
  if table.rows_hash[:'start time'].to_s.include? 'round'
    if Time.now.min <= 30
      local_time = Time.now.change(:min => 0)
    else
      local_time = Time.now.change(:min => 0) + 3600
    end
  end
  if table.rows_hash[:'start time'].to_s.include? '+'
    start_time = (local_time + (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time + (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  elsif table.rows_hash[:'start time'].to_s.include? '-'
    start_time = (local_time - (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time - (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  end
  d = Date.parse(date)
  t_s = Time.parse(start_time)
  t_f = Time.parse(end_time)
  start = DateTime.new(d.year, d.month, d.day, t_s.hour, t_s.min, t_s.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  if t_s < t_f
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  else
    d = Date.parse(date) + 1
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  end
  desc = table.rows_hash[:description]
  v_desc = table.rows_hash[:'venue description']
  location = table.rows_hash[:location]
  number_of_workers = table.rows_hash[:'number of workers']
  promocode = table.rows_hash[:promocode]
  API.create_gig_with_promo(role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers, promocode)
end

And(/^API deletes latest gig$/) do
  API.delete_latest_gig
end

And(/^API deletes latest vacancy$/) do
  API.delete_latest_vacancy
end