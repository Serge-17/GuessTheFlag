//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Serge Eliseev on 22.02.2025.
//

import SwiftUI


import SwiftUI

struct FlagImage: View {
    var image: Image
    var body: some View {
        image
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}




struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var answer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var messageTitle = ""
    
    @State private var correctAnswer = 0
    @State private var errorAnswer = 0
    @State private var countAnswer = 0
    @State private var gameOver = false
    @State private var gameOverTitle = "Конец игры!"
    
    @State private var animationAmount = 0.0
    @State private var selectedFlag: Int?
    @State private var animationAmountScale: CGFloat = 1.0


    
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[answer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            selectedFlag = number
                            flagTapped(number)
                        } label: {
                            FlagImage(image: Image(countries[number]))
                                .opacity(selectedFlag != nil && number != answer ? 0.25 : 1.0)
                                .scaleEffect(selectedFlag != nil && number != selectedFlag ? 0.75 : 1)
                        }
                        .rotation3DEffect(
                             .degrees(selectedFlag == number ? animationAmount : 0),
                             axis: (x: 0, y: 1, z: 0)
                         )
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()
                
                VStack {
                    Text("Статистика игрока:")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                        .padding(.bottom, 8)
                    
                    Text("Всего вопросов: \(countAnswer)")
                        .padding(.bottom, 5)
                    Text("Правильный ответ: \(correctAnswer)")
                        .padding(.bottom, 5)
                    
                    Text("Ошибочный ответ: \(errorAnswer)")
                        .padding(.bottom, 5)
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(messageTitle)
        }
        .alert("Игра закончена. Повторим?", isPresented: $gameOver) {
            Button("Да", action: restartGame)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == answer {
            scoreTitle = "Правильно"
            correctAnswer += 1
            countAnswer += 1
            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                animationAmount += 360
            }
           
        } else {
            scoreTitle = "Ошибка"
            messageTitle = "Неверно! Это флаг \(countries[answer])"
            errorAnswer += 1
            countAnswer += 1
            
        }
        showingScore = true
        selectedFlag = 0
       
    }
    
    func askQuestion() {
        withAnimation {
            selectedFlag = nil // Сбрасываем выбор
            animationAmount = 0 // Сбрасываем анимацию
        }
        if countAnswer <= 7 {
            countries.shuffle()
            answer = Int.random(in: 0...2)
        } else {
            gameOver = true
        }
        
    }
    
    func restartGame() {
        correctAnswer = 0
        errorAnswer = 0
        countAnswer = 0
        gameOver = false
    }
    
}

#Preview {
    ContentView()
}



//        @State private var animationAmount: CGFloat = 1.0
//        
//        var body: some View {
//            Button("Нажми меня") {
//                animationAmount += 0.5 // Увеличиваем масштаб при каждом нажатии
//            }

//            .scaleEffect(animationAmount) // Применяем масштабирование
//            .animation(.easeInOut, value: animationAmount) // Добавляем анимацию
//        }
   
