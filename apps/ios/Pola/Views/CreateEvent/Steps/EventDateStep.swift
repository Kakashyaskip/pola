import SwiftUI

struct EventDateStep: View {
    @Bindable var vm: CreateEventViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quand se termine\nvotre événement ?")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("Les invités pourront prendre des photos jusqu'à cette date.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            // Calendrier
            DatePicker(
                "Date de fin",
                selection: $vm.endDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .colorScheme(.dark)
            .tint(.polaOrange)
            .padding(.horizontal, 12)

            Spacer()

            NextButton { vm.next() }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
        }
    }
}
