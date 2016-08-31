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

  end
end