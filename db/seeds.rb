# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

NUM_PATIENTS = 100
NUM_PHYSICIANS = 100
APPOINTMENTS = 500

NUM_PATIENTS.times { Patient.create(name: Faker::Name.name) }
NUM_PHYSICIANS.times { Physician.create(name: Faker::Name.name) }

prng = Random.new
APPOINTMENTS.times do
  physician_id = prng.rand(NUM_PHYSICIANS)
  patient_id = prng.rand(NUM_PATIENTS)
  fake_date = Faker::Time.between(DateTime.now, DateTime.now + 365)
  Appointment.create(
    appointment_date: fake_date,
    physician_id: physician_id,
    patient_id: patient_id
  )
end
