namespace :query_benchmark do
  task run: :environment do
    query = <<QUERY
{
  appointment(id: 1) {
    appointment_date
  }
}
QUERY

    query_without_loader = <<QUERY
{
  appointment_without_loader(id: 1) {
    appointment_date
  }
}
QUERY

    Benchmark.ips do |x|
      x.report('graphql') { ::RootSchema.execute(query) }
      x.report('graphql without loader') { ::RootSchema.execute(query_without_loader) }
      x.report('normal') do
        appoint = Appointment.find(1)

        {
          'data' => {
            'appointment' => {
              'appointment_date' => appoint.appointment_date.to_s
            }
          }
        }
      end

      x.compare!
    end
  end
end
