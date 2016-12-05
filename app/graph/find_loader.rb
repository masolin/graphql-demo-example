class FindLoader < GraphQL::Batch::Loader
  def initialize(model)
    @model = model
  end

  def perform(ids)
    records = @model.where(id: ids.uniq)
    records.each { |record| fulfill(record.id, record) }
    # If a record wasnt found, fulfill with nil:
    ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
  end
end