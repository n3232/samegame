import UIKit

struct Card<CardContent> {
    var value: CardContent
    var rowIndex: Int
    var columIndex: Int
    var isFixed: Bool = false
}

struct CardsState {
    static let numberOfRows =  5
    static let numberOfColumns = 5
//    let cardValues = ["👻", "🐤"]
    let cardValues = ["👻"]
//    let cardValues = ["👻", "🐤", "🍄"]

    var cards = [[Card<String>]]()

    mutating func reset() {
        for _ in 0..<CardsState.numberOfRows {
            var row:[Card<String>] = []
            for j in 0..<CardsState.numberOfColumns {
                let value = cardValues.randomElement()!
                let card = Card(value: value, rowIndex: 0, columIndex: j)
                row.append(card)
            }
            cards.append(row)
        }
    }

    func printCards() {
        for cardRows in cards {
            var cardRow = ""
            for card in cardRows {
                if card.isFixed {
                    cardRow += "[  ]"
                } else {
                    cardRow += "[\(card.value)]"
                }
            }
            print(cardRow)
        }
        print("---------")
    }

    func existsIndex(targetRowIndex: Int, targetColoumIndex: Int) -> Bool {
        0 <= targetColoumIndex && targetColoumIndex < Self.numberOfColumns
            && 0 <= targetRowIndex && targetRowIndex < Self.numberOfRows
    }
}

struct Score {

    private (set) var totalValue: Int
    var value: Int {
        didSet {
            totalValue +=  value
        }
    }
}
enum GameState {
    case newGame
    case notSelected
    case selecded
    case gameOver
    case clear
}

func tapedCard(rowIndex: Int, coloumIndex: Int) {
    updateCards(rowIndex: rowIndex, coloumIndex: coloumIndex)
    updateScore()
}

func updateCards(rowIndex: Int, coloumIndex: Int) {
    let selectedCardValue = cardsState.cards[rowIndex][coloumIndex].value

    // タップされたカードの右側にあるカードを消す
    deleteMatchCards(selectedCardValue, rowIndex, coloumIndex, getTargetRowIndex: { $0 }, getTargetColoumIndex: { $0 + 1 })
    // タップされたカードの左側にあるカードを消す
    deleteMatchCards(selectedCardValue, rowIndex, coloumIndex, getTargetRowIndex: { $0 }, getTargetColoumIndex: { $0 - 1 })
    // タップされたカードの下側にあるカードを消す
    deleteMatchCards(selectedCardValue, rowIndex, coloumIndex, getTargetRowIndex: { $0 + 1 }, getTargetColoumIndex: { $0 })
    cardsState.printCards()
}

// 隣り合う同じカードを消す
func deleteMatchCards(_ selectedCardValue: String, _ rowIndex: Int, _ coloumIndex: Int,
                      getTargetRowIndex: (Int) -> Int, getTargetColoumIndex: (Int) -> Int) {
    if let isMatch = isMatchCard(selectedCardValue: selectedCardValue,
                                 rowIndex: rowIndex, coloumIndex: coloumIndex,
                                 getTargetRowIndex: getTargetRowIndex,
                                 getTargetColoumIndex: getTargetColoumIndex) {

        // 隣のカードが同じ場合
        if isMatch {
            cardsState.cards[rowIndex][coloumIndex].isFixed = true
            cardsState.cards[rowIndex][getTargetColoumIndex(coloumIndex)].isFixed = true
            // 隣のカードに対して再起呼び出し
            deleteMatchCards(selectedCardValue,
                             getTargetRowIndex(rowIndex),
                             getTargetColoumIndex(coloumIndex),
                             getTargetRowIndex: getTargetRowIndex,
                             getTargetColoumIndex: getTargetColoumIndex)
        }
    }
}

// getNextColoumIndexのカードがselectedCardValueと一致する場合trueを返す。一致しない場合falseを返す。
// getNextColoumIndexのカードが存在しない場合はnilを返す。
//getTargetCard
func isMatchCard(selectedCardValue: String,
                 rowIndex: Int,
                 coloumIndex: Int,
                 getTargetRowIndex: (Int) -> Int,
                 getTargetColoumIndex: (Int) -> Int) -> Bool? {

    let targetColoumIndex = getTargetColoumIndex(coloumIndex)
    let targetRowIndex = getTargetRowIndex(rowIndex)

    // カードインデックスが存在するか確認
    guard cardsState.existsIndex(targetRowIndex: targetRowIndex, targetColoumIndex: targetColoumIndex) else {
        return nil
    }
    let targetCardValue = cardsState.cards[rowIndex][targetColoumIndex].value
    return selectedCardValue == targetCardValue
}



func updateScore() {
    score.value += 1
}

struct Game {
    var score: Score
    var cards: CardsState
//    var gameState: GameState

}
func startNewGame() {
    cardsState.reset()
    cardsState.printCards()
}




var cardsState = CardsState()
var score = Score(totalValue: 0, value: 0)
var game = Game(score: score, cards: cardsState)

startNewGame()

//tapedCard(rowIndex: 0, coloumIndex: 0)
//tapedCard(rowIndex: 0, coloumIndex: 1)
tapedCard(rowIndex: 2, coloumIndex: 2)




