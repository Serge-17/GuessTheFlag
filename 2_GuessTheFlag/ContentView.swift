// ContentView.swift
// 2_GuessTheFlag
//
// Created by Serge Eliseev on 9/12/24.
//

import SwiftUI

struct Flag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}
extension View {
    func FlagImage() -> some View {
        modifier(Flag())
    }
}

// Основная структура ContentView, которая содержит логику отображения игры и управления состояниями.
struct ContentView: View {
    // Переменная @State для хранения массива стран. Эти страны будут перемешаны случайным образом с помощью метода shuffled().
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    
    // Словарь, который сопоставляет названия стран с их переводами на русский язык.
    let countriesDictionary: [String: String] = [
        "Estonia": "Эстонии", "France": "Франции", "Germany": "Германии", "Ireland": "Ирландии",
        "Italy": "Италии", "Nigeria": "Нигерии", "Poland": "Польши", "Spain": "Испании",
        "UK": "Англии", "US": "Америки"
    ]
    
    // Переменная для хранения правильного ответа, случайно выбираемого из индексов 0, 1 или 2.
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Переменные @State для отслеживания показа алертов и их содержания.
    @State private var showingScore = false  // Отвечает за показ алерта.
    @State private var scoreTitle = ""       // Заголовок алерта (например, "Правильно" или "Неправильно").
    @State private var messageAnswer = ""    // Сообщение алерта с дополнительным текстом.

    // Переменные для подсчета количества правильных и неправильных ответов, а также общего количества попыток.
    @State private var answerCorrect = 0
    @State private var answerWrong = 0
    @State private var attemptAnswer = 0     // Счётчик попыток (максимум — 8).

    // Переменная @State для отслеживания завершения игры.
    @State private var gameOver = true

    // Основное тело View, которое описывает интерфейс игры.
    var body: some View {
        ZStack {
            // Задний фон с градиентом для красивого визуального эффекта.
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: UnitPoint.top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()

            // Основной стек для размещения всех элементов на экране.
            VStack {
                Spacer()

                // Заголовок игры "Guess the Flag".
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                // Внутренний VStack, содержащий вопрос и кнопки с флагами.
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.semibold))
                        // Текст с названием страны, которую нужно выбрать.
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    // Кнопки для выбора флага. Генерируются циклом ForEach.
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number) // Вызов функции обработки выбора флага.
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule) // Придание изображению формы капсулы.
                                .shadow(radius: 5)   // Тень для визуального эффекта.
                        }
                    }
                }
                .FlagImage()

                Spacer()
                Spacer()

                // Отображение счёта игры, количества правильных и неправильных ответов, а также оставшихся попыток.
                VStack {
                    Text("Score: ???")
                        .foregroundStyle(.secondary)
                        .font(.title.bold())
                    VStack {
                        Text("Правильно: \(answerCorrect)")
                        Text("Ошибка: \(answerWrong)")
                        Text("Попытки: \(attemptAnswer) из 8")
                    }
                    .font(.title2.weight(.semibold))
                    .frame(alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 30))

                Spacer()
            }
            .padding()
        }
        // Модификатор алерта, который будет показан, если showingScore == true.
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion) // Кнопка "Continue" для продолжения игры.
        } message: {
            Text("\(messageAnswer)") // Сообщение внутри алерта.
        }
    }

    // Функция, которая вызывается при выборе флага.
    func flagTapped(_ number: Int) {
        // Проверка, был ли выбран правильный флаг.
        if number == correctAnswer {
            scoreTitle = "Correct"
            messageAnswer = "Правильно"
            answerCorrect += 1
        } else {
            scoreTitle = "Wrong"
            // Если выбран неправильный флаг, сообщение выводит страну правильного флага.
            messageAnswer = "Неправильно! Это флаг \(countriesDictionary[countries[correctAnswer]]!)"
            answerWrong += 1
        }

        // Обновление количества попыток.
        attemptAnswer = answerCorrect + answerWrong

        // Проверка, если количество попыток достигло 8 — завершение игры.
        if attemptAnswer >= 8 {
            scoreTitle = "Конец игры!"
            answerCorrect = 0
            answerWrong = 0
            // Показываем финальный алерт.
            showingScore = true
        } else {
            // Если попытки не закончились, показываем промежуточный результат.
            showingScore = true
        }
    }

    // Функция, которая перезапускает вопрос: перемешивает страны и выбирает новый правильный ответ.
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


#Preview {
    ContentView()
}
