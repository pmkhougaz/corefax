class ProjectAverageCalculator
  def initialize(project_id, cost_code_id)
    @project_id = project_id
    @cost_code_id = cost_code_id
  end

  def execute
    averages = []
    average_per_month.keys.each do |key|
      averages << { date: Date.new(2016, key.to_f, 1).iso8601, price: average_per_month[key] }
    end

    averages
  end


  def average_per_month
    averages = {}
    line_items_by_month.keys.each do |key|
      unit_costs = []

      line_items_by_month[key].flatten.each do |li|
        unit_costs << li["unit_cost"].to_f unless li["unit_cost"].nil?
      end

      if unit_costs.reduce(:+).nil?
      end
      average = unit_costs.reduce(:+) / unit_costs.size.to_f

      averages[key] = average
    end

    averages
  end

  def line_items_by_month
    purchase_order_line_items.group_by{ |i| i.first.try(:[], "updated_at").try(:split, '-').try(:second) }
  end

  def purchase_order_line_items
    line_items = []
    purchase_order_ids.uniq.each do |id|
      line_items << ApiClient.instance.get(url: "/purchase_order_contracts/#{id}/line_items", query: { project_id: @project_id })
    end
    line_items
  end

  def purchase_order_ids
    ids = []
    purchase_orders_request.uniq.each do |por|
      ids << por["id"]
    end

    ids
  end

  def purchase_orders_request
    ApiClient.instance.get(url: "/purchase_order_contracts", query: { project_id: @project_id })
  end
end