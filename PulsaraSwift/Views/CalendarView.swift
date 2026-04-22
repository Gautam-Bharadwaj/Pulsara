import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Calendar")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Calendar Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .accentColor(PulsaraTheme.primary)
                    .padding()
                    .background(PulsaraTheme.surface)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .colorScheme(.dark)

                // Entries for selected date
                VStack(alignment: .leading, spacing: 16) {
                    Text("Entries for \(selectedDate.formatted(date: .long, time: .omitted))")
                        .font(.headline)
                        .foregroundColor(PulsaraTheme.textSecondary)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            Text("No entries for this date.")
                                .foregroundColor(PulsaraTheme.textDim)
                                .padding(.top, 40)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
