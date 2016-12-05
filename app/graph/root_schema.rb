PhysicianType = GraphQL::ObjectType.define do
  name 'Physician'

  field :name, types.String
end

PatientType = GraphQL::ObjectType.define do
  name 'Patient'

  field :name, types.String
end

AppointmentType = GraphQL::ObjectType.define do
  name 'Appointment'

  field :appointment_date, types.String
  field :physician, PhysicianType
  field :patient, PatientType
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  field :appointment, AppointmentType do
    argument :id, types.Int
    resolve -> (obj, args, ctx) { Appointment.find(args[:id]) }
  end
end

RootSchema = GraphQL::Schema.define do
  query QueryType
end
