//
//  AppView.swift
//  julienne
//
//  Created by Ben McMahen on 2019-06-27.
//  Copyright © 2019 Ben McMahen. All rights reserved.
//

import SwiftUI


struct AppView : View {
    @EnvironmentObject var session: SessionStore
    @ObjectBinding var recipeStore = RecipeStore()
    @State var query = ""
    
    
    func fetchRecipes () {
        print("Fetching recipes")
        recipeStore.fetch(userId: self.session.session!.uid)
    }

    
    var body: some View {
        
        
        return NavigationView {
            
            List {
                Section() {
                    NavigationLink(destination: Text("Hello")) {
                        Text("Following").fontWeight(.semibold).padding(.vertical)
                    }
                    NavigationLink(destination: Text("Hello")) {
                        Text("Followers").fontWeight(.semibold).padding(.vertical)
                    }
                }
                
                Section(header: Text("Your recipes")) {
                    ForEach(recipeStore.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeListItem(recipe: recipe)
                        }
                    }
                }
            }
                .navigationBarTitle(Text("Julienne"), displayMode: .inline)
                .navigationBarItems(leading: PresentationLink(destination: SessionInfo().environmentObject(session)) {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .accessibility(label: Text("user profile"))
                    
                    },
                    
                    trailing: HStack(spacing: 24) {
                        Button(action: { print("search") }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .accessibility(label: Text("search recipes"))
                            
                        }
                        PresentationLink(destination: ComposeRecipe()) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                                .accessibility(label: Text("Add recipe"))
                            
                        }
                      
                    }
            )
            
        
          
            }.onAppear(perform: fetchRecipes)
    }
}

#if DEBUG
struct AppView_Previews : PreviewProvider {
    static var previews: some View {
        AppView(recipeStore: RecipeStore(recipes: [Recipe.default]))
            .environmentObject(SessionStore(session: User.default))
    }
}
#endif
