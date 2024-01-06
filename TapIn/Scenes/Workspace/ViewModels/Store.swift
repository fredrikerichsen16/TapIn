//import Foundation
//import SwiftUI
//import RealmSwift
//import Combine
//
//// MARK: Store
//
//struct _State {
//    var pomodoro: Pomodoro
//    var launcher: Launcher
//    var radio: Radio
//    var blocker: Blocker
//}
//
//extension _State {
//    struct Pomodoro {
//        var timerMode: TimerMode = .initial
//        var isActive: Bool = false
//    }
//    
//    struct Launcher {
//        var selectedItem: Int = 0
//    }
//    
//    struct Radio {
//        var channel: Int = 0
//        var isActive: Bool = false
//    }
//    
//    struct Blocker {
//        var isActive: Bool = false
//    }
//}
//
//enum Action {
//    // Layout
//    case toggleActive
//}
//
//typealias Reducer<S, A> = (inout S, A) -> Void
//
//func reducer(_ state: inout _State, _ action: Action) {
//    switch action
//    {
//    // Layout
//    case .layoutToggle(let subscene):
//        state.layout.toggle(subscene)
//
//    case .layoutSwitchOrientation:
//        state.layout.switchOrientation()
//
//    case .setBookPage(let page):
//        state.bookState?.page = page
//
//        guard let chapter = state.outlineContainer.getOutlineItem(.page(page)) else {
//            return
//        }
//
//        state.bookState?.chapter = chapter
//
//    // Book
//    case .createFlashcardFromSelection(let selection):
//        guard let bookState = state.bookState else {
//            return
//        }
//
//        state.layout.unhide(.flashcards)
//
//        let bookChapter = bookState.chapter.chapter
//
//        guard let flashcardChapter = state.outlineContainer.getOutlineItem(.chapter(bookChapter), depthLimited: true) else {
//            return
//        }
//
//        var input = FlashcardInput()
//            input.answer = CodedTextViewContents(string: selection)
//            input.outlineItem = flashcardChapter.realmObject
//            input.page = bookState.page
//
////        state.flashcardsState.tab = .create
//        //    flashcardsState.flashcardInput = input
//        //    flashcardsState.changeTab(to: .create)
//
//    case .goToPrevChapterInNotes:
//        let outlineContainer = state.outlineContainer
//        let currentChapter = state.notesState.chapter.chapter
//
//        if let prevChapter = outlineContainer.getOutlineItem(.previousBefore(currentChapter)) {
//            state.notesState.chapter = prevChapter
//        }
//
//    case .goToNextChapterInNotes:
//        let outlineContainer = state.outlineContainer
//        let currentChapter = state.notesState.chapter.chapter
//
//        if let prevChapter = outlineContainer.getOutlineItem(.nextAfter(currentChapter)) {
//            state.notesState.chapter = prevChapter
//        }
//
//    // Flashcards
//    case .setTab(let tab):
//        print(tab) // state.flashcardsState.tab = tab
//
//    case .navigateInFlashcards(let route):
//        state.flashcardsState.path.append(route)
//
//    case .goToBrowseInFlashcards:
//        let count = state.flashcardsState.path.count
//        state.flashcardsState.path.removeLast(count)
//
//    case .overwritePathInFlashcards(let path):
//        state.flashcardsState.path = path
//    
//    case .goBackInFlashcardsPath:
//        state.flashcardsState.path.removeLast(1)
//    }
//}
//
//typealias ReaderStore = Store<ReaderState, ReaderAction>
//
//final class Store<State, Action>: ObservableObject {
//    @Published private(set) var state: State
//    private var reducer: Reducer<State, Action>
//
//    init(state: State, reducer: @escaping Reducer<State, Action>) {
//        self.state = state
//        self.reducer = reducer
//    }
//
//    func send(_ action: Action) {
//        reducer(&state, action)
//    }
//}
