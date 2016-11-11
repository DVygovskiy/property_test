class Calendar

  attr_accessor :dates
  attr_accessor :month_label
  attr_accessor :month_button

  def initialize(page, table = {})
    @page = page
    @type = ""
  end

  def define_month(month)
    @month_label = @page.find_element(@page.send("month_label"))
    @month_button = @page.find_element(@page.send("month_button"))
    until @month_label.has_content?("#{month}")
      @page.click_the(@month_button)
      sleep(0.5)
    end
  end

  def set_dates(table = {})
    @days = @page.find_all_elements(@page.send("days"))
    @many_month = false
    @arr = []
    unless table == {}
      table.transpose.raw[0].each do |text|
        if text.to_s.include? "from"
          @type = "row"
          @arr << text.split[1]+" "+text.split[2]
          @arr << text.split[4]+" "+text.split[5]
        else
          @arr << text
        end
      end
    end
    dates = Hash.new.compare_by_identity
    @arr.each do |date|
      dates[date.to_s.split[1]] = date.to_s.split[0]
    end
    if dates.keys.uniq.count == 2
      @many_month = true
      dates = dates.group_by { |elem| elem[0] }
      dates_f_month = []
      dates_s_month = []
      dates[dates.keys.uniq[0]].each { |elem| dates_f_month << elem[1] }
      dates[dates.keys.uniq[1]].each { |elem| dates_s_month << elem[1] }
    else
      dates = dates.values
    end
    if @many_month == false
      path = @days[0].path
      dates.each do |date|
        @page.all(:xpath, "#{path}/tbody/tr").each do |row|
          nodes_path = row.path + "/child::*"
          node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, date) }
          unless node == nil
            break @page.click_the(node)
          end
        end
      end
    else
      path_f_month = @days[0].path
      path_s_month = @days[1].path
      dates_f_month.each do |date|
        @page.all(:xpath, "#{path_f_month}/tbody/tr").each do |row|
          nodes_path = row.path + "/child::*"
          node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, date) }
          unless node == nil
            break @page.click_the(node)
          end
        end
      end
      dates_s_month.each do |date|
        @page.all(:xpath, "#{path_s_month}/tbody/tr").each do |row|
          nodes_path = row.path + "/child::*"
          node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, date) }
          unless node == nil
            break @page.click_the(node)
          end
        end
      end
    end
  end
end



