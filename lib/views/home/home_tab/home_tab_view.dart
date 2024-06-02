import 'package:flutter/material.dart';
import 'package:gkvk/shared/components/CustomTextButton.dart';
import 'package:gkvk/views/generateid/GenerateFarmersId_view.dart';

class HomeTabView extends StatelessWidget{
  const HomeTabView({super.key});


  // HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF3F3F3),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                text: 'CREATE NEW ID',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateFarmersIdPage()),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("ENTER WATER-SHED"),
                      ),
                    ),
                  )),
                  const SizedBox(width: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF8DB600),
                    ),
                    child: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.arrow_right_alt_rounded)
                    ),
                  )

                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("ENTER FARMER ID TO EDIT PROFILE"),
                      ),
                    ),
                  )),
                  const SizedBox(width: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF8DB600),
                    ),
                    child: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.arrow_right_alt_rounded)
                    ),
                  )

                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("ENTER FARMER ID FOR UPDATE"),
                      ),
                    ),
                  )),
                  const SizedBox(width: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF8DB600),
                    ),
                    child: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.arrow_right_alt_rounded)
                    ),
                  )

                ],
              ),
            ],
          ),
        )
    );
  }


}