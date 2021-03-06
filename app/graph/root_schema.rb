PhysicianType = GraphQL::ObjectType.define do
  name 'Physician'
  description 'This is a physician'

  field :name, types.String
  connection :appointments, AppointmentType.connection_type
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
  field :type, types.String do
    resolve -> (_, _, _) { 'test' }
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

  field :appointment_without_loader, AppointmentType do
    argument :id, types.Int
    resolve -> (obj, args, ctx) do
      Appointment.find(args[:id])
    end
  end

  field :physician, PhysicianType do
    argument :id, types.Int
    resolve -> (_, args, _) do
      Physician.find(args[:id])
    end
  end
end

MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  field :createPatient, field: CreatePatientMutation.field
end


CreatePatientMutation = GraphQL::Relay::Mutation.define do
  name 'CreatePatient'

  input_field :name, !types.String

  return_field :patient, PatientType

  resolve -> (_, args, _) do
    patient = Patient.create(name: args[:name])

    {
      patient: patient
    }
  end
end

RootSchema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
RootSchema.query_execution_strategy = GraphQL::Batch::ExecutionStrategy
