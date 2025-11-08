 class TextListItem
 {
   late int id;
   late String title;


   TextListItem({required this.id, required this.title});


   factory TextListItem.fromJson(Map<String, dynamic> json) {
     return TextListItem(
       id: int.parse(json['id']),
       title: json['title'] as String
     );
   }

   // Метод для преобразования объекта в JSON
   Map<String, dynamic> toJson() {
     return {
       'id': id,
       'title': title
     };
   }


 }