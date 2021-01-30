import SwiftUI
import CardStack

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
    
    static let mock: [Photo] = [
        Photo(image: UIImage(named: "sc1")!),
        Photo(image: UIImage(named: "sc2")!),
        Photo(image: UIImage(named: "sc3")!),
        Photo(image: UIImage(named: "sc4")!),
    ]
}

struct CardView: View {
    let photo: Photo
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Image(uiImage: self.photo.image)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.width)
                    .clipped()
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .padding()
    }
}

var cardStack = CardStack(
    direction: LeftRight.direction,
    data: Photo.mock,
    onSwipe: { card, direction in
        print("Swiped \(direction)")
        
        if direction == .right {
            print("우측")
            NavigationLink(
                destination: AddLabelingView(),
                label: {
                    Text("라벨링 추가")
                })
        }
    },
    content: { photo,_,_  in
        CardView(photo: photo)
    }
    )

var onClickRight = CardStack(
    direction: LeftRight.direction,
    data: Photo.mock,
    onSwipe: { card, direction in
        print("Swiped \(direction)")
    },
    content: { photo,_,_  in
        CardView(photo: photo)
    }
    )

struct MainLabelingView: View {
    @State var data: [Photo] = Photo.mock
  
    var body: some View {
        NavigationView{
            VStack {
                Text(" 지금 라벨링 할까요?")
                    .padding()
            cardStack
            .padding()
            .scaledToFit()
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("N")
                })
                .padding(50.0)
                
                Button(action: {
                    onClickRight
                }, label: {
                    Text("Y")
                }).padding(50.0)
            }.padding(30)
        
            }
        }
    }
}
    
    //tag : 0 -> Yes tag: 1 -> NO
  


struct MainLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        MainLabelingView()
    }
}
 
 
