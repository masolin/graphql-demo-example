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
  field :physician, PhysicianType do
    resolve -> (obj, _, _) { FindLoader.for(Physician).load(obj.physician_id) }
  end
  field :patient, PatientType do
    resolve -> (obj, _, _) { FindLoader.for(Patient).load(obj.patient_id) }
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  field :appointment, AppointmentType do
    argument :id, types.Int
    resolve -> (obj, args, ctx) do
      FindLoader.for(Appointment).load(args[:id])
    end
  end
end

RootSchema = GraphQL::Schema.define do
  query QueryType
end
RootSchema.query_execution_strategy = GraphQL::Batch::ExecutionStrategy
