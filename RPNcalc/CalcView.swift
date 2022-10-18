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
        
    ]

    var body: some View{
        GeometryReader{ geom in
            let isLandscape = geom.size.width > geom.size.height
            
            VStack {
                DisplayView(text: "3.143143245653765")
                    .frame(height: geom.size.height * (isLandscape ? 0.13 : 0.15))
                    .padding([.top, .leading, .trailing])
                KeypadView().padding()
                 
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
    var body: some View{
        GeometryReader{ geom in
            let isLandscape = geom.size.width > geom.size.height
            EmptyView()
            
            
            
//            if isLandscape {
//                VStack{
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                }
//            }
//            else{
//                VStack{
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                    HStack{
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    Keyview()
//                    }
//                }
//            }
        }
        
    }
}

struct Keyview : View{
    let key : CalcKey
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 8)
            shape.fill(.cyan.opacity(0.7))
            Text(key.symbol)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct CalcKey : Hashable {
    let symbol : String
    
    
    init(_ symbol : String, _ potrait: (row: Int, column: Int), _ landscape: (row: Int, column: Int))

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

