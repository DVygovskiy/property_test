class Calendar

  attr_accessor :month_label
  attr_accessor :month_button

  def initialize(page, table = {})
    @page = page
    @type = ""

    @month_label = "//div[@class='months']/div[1]"
    @month_button = "//div[@class='clndr-control-button rightalign']"
  end

  def define_month(month)
    until @page.find_element(@month_label).has_content?("#{month}")
      @page.click_the(@page.find_element(@month_button))
      sleep(0.5)
    end
  end

  def set_dates(table = {})
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
    if @type == "row"
      if dates.keys.uniq.count == 2
        @many_month = true
        dates = dates.group_by { |elem| elem[0] }
        dates_f_month = []
        dates_s_month = []
        dates[dates.keys.uniq[0]].each { |elem| dates_f_month << elem[1] }
        dates[dates.keys.uniq[1]].each { |elem| dates_s_month << elem[1] }
        @first_day = dates_f_month.first()
        @last_day = dates_s_month.first()
      else
        @first_day = dates.values.first
        @last_day = dates.values.last
      end
    else
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
    end
    if @type == "row"
      @page.all(:xpath, "//table[1]/tbody/tr").each do |row|
        nodes_path = row.path + "/child::*"
        node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, @first_day) }
        unless node == nil
          break @page.click_the(node)
        end
      end
      if @many_month == false
        @page.all(:xpath, "//table[1]/tbody/tr").each do |row|
          nodes_path = row.path + "/child::*"
          l_node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, @last_day) }
          unless l_node == nil
            break @page.click_the(l_node)
          end
        end
      else
        @page.all(:xpath, "//table[2]/tbody/tr").each do |row|
          nodes_path = row.path + "/child::*"
          node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, @last_day) }
          unless node == nil
            break @page.click_the(node)
          end
        end
      end
    else
      if @many_month == false
        dates.each do |date|
          @page.all(:xpath, "//table[1]/tbody/tr").each do |row|
            nodes_path = row.path + "/child::*"
            node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, date) }
            unless node == nil
              break @page.click_the(node)
            end
          end
        end
      else
        dates_f_month.each do |date|
          @page.all(:xpath, "//table[1]/tbody/tr").each do |row|
            nodes_path = row.path + "/child::*"
            node = @page.all(:xpath, "#{nodes_path}").detect { |node| @page.check_element_attr(node, date) }
            unless node == nil
              break @page.click_the(node)
            end
          end
        end
        dates_s_month.each do |date|
          @page.all(:xpath, "//table[2]/tbody/tr").each do |row|
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
end


