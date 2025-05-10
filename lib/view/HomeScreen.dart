import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/view/SearchScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: AbsorbPointer(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: MyColors.searchInput,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const CupertinoSearchTextField(
                  placeholder: 'Tìm kiếm',
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Các học phần",
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //cho nay sau connect data thì get list la duoc
                      //day dang fix data cung
                      listGrade("LESSION 11 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 12 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 13 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 14 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 15 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      //ấn vào đây thì chuyển sang trang show full list học phần
                      IconButton(
                          onPressed: () {

                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                Text(
                  " Tương tự học phần của user.name",
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //cho nay sau connect data thì get list la duoc
                      //day dang fix data cung
                      listGrade("LESSION 11 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 12 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 13 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 14 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      listGrade("LESSION 15 (Submarine Reading", 'https://i.pravatar.cc/300'),
                      //ấn vào đây thì chuyển sang trang show full list học phần
                      IconButton(
                          onPressed: () {

                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.backgroundColor,
                      border: Border.all(
                        color: MyColors.searchInput,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.folder,
                            color: Colors.yellow,
                            size: screenWidth * 0.15,
                          ),
                          Text(
                            "Học phần",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sắp xếp các học phần cho những chủ đề khác nhau mà bạn đang học",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: MyColors.backgroundColor,
                                border: Border.all(
                                  color: MyColors.searchInput,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  'Thêm học phần',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ),
              ],
            ),
        )
      ),
    );
  }
  Widget listGrade(String title, String url) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 270,
        child: GestureDetector(
          onTap: () {
            print('Tapped on $title');
          },
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.backgroundColor,
              border: Border.all(
                color: MyColors.searchInput,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      tag("70 thuật ngữ"),
                      const SizedBox(width: 8),
                      tag("Ảnh", icon: Icons.image),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(url),
                      ),
                      const SizedBox(width: 8),
                      Text("author", style: const TextStyle(color: Colors.white)),
                      const Spacer(),
                      const Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget tag(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2B4E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: const TextStyle(
              color: Colors.white,
              fontSize: 12, fontWeight: FontWeight.bold,
           )
          ),
        ],
      ),
    );
  }
}
