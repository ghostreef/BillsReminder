class SeedApplication
  def initialize

  end

  # order matters here, delete all doesn't trigger callbacks
  # destroy_all does trigger callbacks but has to call destroy on each row...pretty slow
  def obliterate
    ActiveRecord::Base.connection.execute('DELETE FROM categories_purposes')
    ActiveRecord::Base.connection.execute('DELETE FROM categories_sources')

    Transaction.delete_all
    Category.delete_all
    CategorySet.delete_all
    Source.delete_all
    Purpose.delete_all
  end


  def seed
    file = File.read('data/purposes.json')
    data = JSON.parse(file)

    purposes = data.map { |datum|
      p = Purpose.create(datum)
      [p.name, p.id]
    }.to_h


    file = File.read('data/sources.json')
    data = JSON.parse(file)

    sources = data.map { |datum|
      datum[:purpose_id] = purposes[datum.delete('purpose')]
      s = Source.create(datum)
      [s.name, s.id]
    }.to_h

    month = Date.today.month
    year = Date.today.year


    (month - 2).upto(month).each do |month|
      data.each_with_index do |datum, index|
        date = Transaction.format_date("#{month}/#{index+1}/#{year}")
        amount = Random.rand(50) * 10
        Transaction.create(date: date, amount: amount, raw_description: datum['name'])
      end
    end


    file = File.read('data/categories.json')
    data = JSON.parse(file)

    categories = data.map { |datum|
      purpose_ids = purposes.values_at(*datum.delete('purposes'))
      source_ids = sources.values_at(*datum.delete('sources'))

      datum[:purpose_ids] = purpose_ids
      datum[:source_ids] = source_ids

      c = Category.create(datum)
      [c.name, c.id]
    }.to_h

    file = File.read('data/sets.json')
    data = JSON.parse(file)

    data.each do |datum|
      datum[:category_ids] = categories.values_at(*datum.delete('categories'))
      CategorySet.create(datum)
    end
  end
end