class Stop
  include Mongoid::Document
  has_many :stop_times
  has_and_belongs_to_many :trips
 
  field :_id, type: Integer, default: ->{ stop_id }
  field :stop_id, type: Integer
  field :name, type: String

  def as_json(options={})
    { id: self._id, name: self.name }
  end
end
