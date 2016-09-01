class SeedAppService
  def initialize

  end

  def obliterate
    ActiveRecord::Base.connection.execute('DELETE * FROM categories_purposes')
    ActiveRecord::Base.connection.execute('DELETE * FROM categories_sources')

    CategorySet.delete_all
    Category.delete_all
    Source.delete_all
    Purpose.delete_all
    Transaction.delete_all
  end


  def seed
    file = File.read('data/purposes.json')
    data = JSON.parse(file)

    purposes = data.map do |datum|
      p = Purpose.create(datum)
      [p.name, p.id]
    end


    file = File.read('data/sources.json')
    data = JSON.parse(file)

    sources = data.map do |datum|
      datum[:purpose_id] = purposes[datum.delete['purpose']]
      s = Source.create(datum)
      [s.name, s.id]
    end

    month = Date.today.month
    year = Date.today.year

    [(month - 2)..month].each do |month|
      data.each_with_index do |datum, index|
        date = Transaction.format_date("#{month}/#{index+1}/#{year}")
        amount = Random.rand(50) * 10
        Transaction.create(date: date, amount: amount, raw_description: datum['source'])
      end
    end


    file = File.read('data/categories.json')
    data = JSON.parse(file)

    categories = data.map do |datum|
      purpose_ids = purposes.values_at(*datum.delete('purposes'))
      source_ids = sources.values_at(*datum.delete('sources'))

      datum[:purpose_ids] = purpose_ids
      datum[:source_ids] = source_ids

      c = Category.create(datum)
      [c.name, c.id]
    end

    file = File.read('data/sets.json')
    data = JSON.parse(file)

    data.each do |datum|
      datum[:category_ids] = categories.values_at(*datum.delete('categories'))
      CategorySet.create(datum)
    end
  end
end