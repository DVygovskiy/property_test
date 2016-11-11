require_relative '../helpers/finder'

class Table

  cattr_accessor :current_search_results
  cattr_accessor :current_row_path
  cattr_accessor :number_of_items

  def initialize(page, context, name_of_table, group = "table")
    if group == "search_result"
      @selector = name_of_table.downcase + "_search_result"
    elsif group == "table"
      @selector = name_of_table.downcase + "_table"
    end
    @page = page
    @context = context
    Table.current_search_results = nil
    Table.current_row_path = nil
  end

  def table_exists?
    begin
      @context.expect(Finder.element_of_page(@page, @selector).visible?)
      Table.current_search_results = Finder.element_of_page(@page, @selector)
      true
    rescue
      puts "There is no visible results/table"
      false
    end
  end

  def cell_exists?(text)
    Table.current_row_path ||= find_from_table(text)
    @context.expect(@page.find_element(Table.current_row_path).has_text? text)
  end

  def first_cell_exists?(text)
    Table.current_row_path ||= find_first_from_table(text)
    @context.expect(@page.find_element(Table.current_row_path).has_text? text)
  end

  def cell_does_not_exist?(text)
    Table.current_row_path ||= find_from_table(text)
    @context.expect(@page.find_element(Table.current_row_path).has_no_text? text)
  end

  def count_items(text)
    if table_exists?
      nodes_path = Table.current_search_results.path + "/child::*"
      nodes = @context.all(:xpath, "#{nodes_path}").each { |node| node.has_content?(text) }
      Table.number_of_items = nodes.count
    else
      Table.number_of_items = 0
    end
  end

  def compare_number_of_items(number, arg, text)
    nodes_path = Table.current_search_results.path + "/child::*"
    node = @context.all(:xpath, "#{nodes_path}").each { |node| node.has_content?(text) }
    if arg.to_s.include? "more"
      @context.expect(node.count == (number.to_i + Table.number_of_items))
    else
      @context.expect(node.count == number.to_i)
    end
  end

  def make_action_in_table(action)
    nodes_path = Table.current_row_path + "/child::*"
    @context.all(:xpath, "#{nodes_path}").each do |node|
      path = node.path
      if @context.all(:xpath, "#{path}/child::*").empty?
        if check_element_attr(node, action)
          @page.click_the(node)
        end
      end
      until @context.all(:xpath, "#{path}/child::*").empty?
        if find_in_child(path, action)
          return
        end
        path = path + "/child::*"
      end
    end
    sleep(1)
  end

  def self.define_table(result)
    Table.current_search_results = result
  end

  private
  def find_in_child(path, atr)
    @context.all(:xpath, "#{path}/child::*").to_a.reverse.each do |node|
      if check_element_attr(node, atr)
        @page.click_the(node)
        return true
      end
    end
    false
  end

  def find_from_table(text)
    Table.current_search_results ||= Finder.element_of_page(@page, @selector)
    rows_path = Table.current_search_results.path + "/child::*"
    node = @context.all(:xpath, "#{rows_path}").detect { |node| node.has_content?(text) }
    unless node == nil
      Table.current_row_path = node.path
    end
  end

  def find_first_from_table(text)
    Table.current_search_results ||= Finder.element_of_page(@page, @selector)
    rows_path = Table.current_search_results.path + "/child::*"
    nodes = @context.all(:xpath, "#{rows_path}").each do |node|
      if node.has_content?(text)
        return Table.current_row_path = node.path
      end
    end
  end

  def check_element_attr(element, query)
    i = false
    unless element == nil
      attr = {:text => element.text,
              :value => element.value,
              :href => element[:href],
              :title => element[:title],
              :innerHtml => element['innerHTML']
      }
      attr.each_key do |key|
        i = true unless attr[key].to_s != query
      end
    end
    return i
  end
end


