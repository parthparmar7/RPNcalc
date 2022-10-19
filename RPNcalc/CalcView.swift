//
//  ContentView.swift
//  RPNcalc
//
//  Created by Parth Parmar on 18/10/22.
//

import SwiftUI

struct CalcView : View{
    static let calcKeys : Set<CalcKey> = [
        CalcKey("1", (2,0), (2,1)),
        CalcKey("2", (2,1), (2,2)),
        CalcKey("3", (2,2), (2,3)),
        CalcKey("4", (1,0), (1,1)),
        CalcKey("5", (1,1), (1,2)),
        CalcKey("6", (1,2), (1,3)),
        CalcKey("7", (0,0), (0,1)),
        CalcKey("8", (0,1), (0,2)),
        CalcKey("9", (0,2), (0,3)),
        CalcKey(".", (3,0), (3,1)),
        CalcKey("0", (3,1), (3,2)),
        CalcKey("return.left", (3,2), (3,3) , 2 , .gray, true),
        CalcKey("/", (0,3), (0,4)),
        CalcKey("*", (1,3), (1,4)),
        CalcKey("-", (2,3), (2,4)),
        CalcKey("+", (3,3), (3,4)),
        CalcKey("+/-", (4,0), (0,0)),
        CalcKey("sqrt", (4,1), (1,0)),
        CalcKey("SIN", (4,2), (2,0)),
        CalcKey("COS", (4,3), (3,0)),
    ]
    
    var keypadLayout: (portrait: [[CalcKey]] , landscape : [[CalcKey]] ) = (
        Self.calcKeys.keys(for: .portrait),
        Self.calcKeys.keys(for: .landscape)
    )

    var body: some View{
        GeometryReader{ geom in
            let isLandscape = geom.size.width > geom.size.height
            
            VStack {
                DisplayView(text: "3.143143245653765")
                    .frame(height: geom.size.height * (isLandscape ? 0.13 : 0.15))
                    .padding([.top, .leading, .trailing])
                KeypadView(layout: keypadLayout).padding()
                 
            }
        }
    }
}

struct DisplayView : View {
    let text : String
    
    var body: some View {
        ZStack(alignment: .trailing){
            let shape = RoundedRectangle(cornerRadius: 8)
                
            shape.stroke(lineWidth: 2)
            shape.fill(.gray)
            Text(text)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 48))
                .lineLimit(1)
        }
    }
}


struct KeypadView : View{
    let layout : (portrait: [[CalcKey]], landscape: [[CalcKey]])
    
    let keys : Set<CalcKey>
    var body: some View{
        GeometryReader{ geom in
            let isLandscape = geom.size.width > geom.size.height
            let keypad = isLandscape ? layout.landscape : layout.portrait
            [CalcKey](keys)
            if isLandscape{
                VStack{
                    
                    ForEach(0..<keypad.endIndex, id: \.self){ row in
                        let keypadRow = keypad[row]
                        HStack{
                            ForEach(0..<keypadRow.endIndex, id: \.self){ column in
                                let key = keypadRow[column]
                                Keyview(key: key).onTapGesture(){
                                    print(key.symbol)
                                }
                            }
                        }
                    }
                }
            }

        }
        
    }
}

struct Keyview : View{
    let key : CalcKey
    
    @State var scale = 1.0
    
    var body: some View {
        
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 8)
            shape.fill(.cyan.opacity(0.7))
            switch key.symbolStyle {
            case .text(let text, let scale):
                Text(text)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                    .scaleEffect(scale)
            case .image(let imageName, let scale):
                Image(systemName: imageName).scaleEffect(scale)
            }
           
        }
        .scaleEffect(scale)
        .onTapGesture{
            let duration = 0.2
            withAnimation(.easeInOut(duration: duration)){ scale = 1.5 }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                scale = 1
            }
        }
    }
}

enum Orientation {
    case portrait
    case landscape
    
    init(_ size: CGSize){ self = size.width > size.height ? .landscape : .portrait }
    var isPortrait : Bool { self == .portrait }
    var isLandscape : Bool { self == .landscape }
}

struct CalcKey {
    let symbol : String
    let layouts: (portrait : Layout, landscape : Layout)
    let color : Color
    let symbolStyle : Style
    
    init(_ symbol : String, _ portrait: (row: Int, column: Int), _ landscape: (row: Int, column: Int),_ scale:Double? = nil, _ color: Color? = nil, _ isImage: Bool = false){
        
        self.symbolStyle = isImage ? Style.image(symbol, scale ?? 2.5 ):
        Style.text(symbol, scale ?? 1.2)
        self.layouts = (
            Layout.portrait(row: portrait.row, column: portrait.column),
            Layout.landscape(row: landscape.row, column: landscape.column)
        )
        self.color = color ?? .cyan
    }
    
    enum Style{
        case text(String, Double = 1)
        case image(String, Double = 2.5)
        
        var symbol: String {
            switch self{
            case .text(let symbol, _): fallthrough
            case .image(let symbol, _): return symbol
            }
        }
        
        var scale: Double{
            switch self{
            case .text(_, let scale):fallthrough
            case .image(_, let scale): return scale
            }
        }
    }
    
    enum Layout {
        case portrait (row: Int, column : Int)
        case landscape (row: Int, column : Int)
        
        var row : Int{
            switch self{
            case .portrait(let row, _): fallthrough
            case .landscape(let row, _): return row
            }
        }
        var column : Int{
            switch self{
            case .portrait(_, let column): fallthrough
            case .landscape(_, let column): return column
            }
        }
    }

}

extension CalcKey : Hashable, CustomStringConvertible{
    
    static func == (lhs: CalcKey, rhs: CalcKey) -> Bool {
        lhs.symbolStyle.symbol == rhs.symbolStyle.symbol
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbolStyle.symbol)
    }
    
    var description: String { symbol }
}

extension Set where Element == CalcKey {
    static let rowPredicate: (CalcKey, CalcKey, Orientation) -> Bool = {
        switch $2{
        case .portrait:
            return $0.layouts.portrait.row < $1.layouts.portrait.row
        case .landscape:
            return $0.layouts.landscape.row < $1.layouts.landscape.row
        }
    }
    static let columnPredicate: (CalcKey, CalcKey, Orientation) -> Bool = {
        switch $2{
        case .portrait:
            return $0.layouts.portrait.column < $1.layouts.portrait.column
        case .landscape:
            return $0.layouts.landscape.column < $1.layouts.landscape.column
        }
    }
    
    func rowRange(for orientation : Orientation) -> ClosedRange<Int> {
        let minKey = self.min(by: {Self.rowPredicate($0, $1, orientation)})!
            
        let maxKey = self.max(by: {Self.rowPredicate($0, $1, orientation)})!
            
            switch orientation{
            case .portrait:
                return minKey.layouts.portrait.row...maxKey.layouts.portrait.row
            case .landscape:
                return minKey.layouts.landscape.row...maxKey.layouts.landscape.row
            }
    }
                              func columnRange(for orientation : Orientation) -> ClosedRange<Int> {
                                  let minKey = self.min(by: {Self.columnPredicate($0, $1, orientation)})!
                                      
                                  let maxKey = self.max(by: {Self.columnPredicate($0, $1, orientation)})!
                                      
                                      switch orientation{
                                      case .portrait:
                                          return minKey.layouts.portrait.column...maxKey.layouts.portrait.column
                                      case .landscape:
                                          return minKey.layouts.landscape.column...maxKey.layouts.landscape.column
                                      }
                              }
    func keys(for orientation: Orientation) -> [[CalcKey]]{
        let keys = self.sorted(by: {Self.rowPredicate($0,$1, orientation)})
        
                                      switch orientation{
                                      case .portrait:
                                          return rowRange(for: orientation)
                                              .map{row in keys.filter{ Key in
                                                  Key.layouts.portrait.row == row }.sorted{
                                                      Self.columnPredicate($0,$1,orientation)
                                                  }
                                              }
                                      case .landscape:
                                          return rowRange(for: orientation)
                                              .map{row in keys.filter{ Key in
                                                  Key.layouts.portrait.row == row }.sorted{
                                                      Self.columnPredicate($0,$1,orientation)
                                                  }
                                              }
                                    
                                      }
        [[CalcKey]]()
    }
}


struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CalcView()
                .preferredColorScheme(.light) //to see the view on the right, useful for debugging
            CalcView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }

