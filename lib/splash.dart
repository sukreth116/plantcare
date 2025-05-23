// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _coffeeController;
//   bool copAnimated = false;
//   bool animateCafeText = false;

//   @override
//   void initState() {
//     super.initState();
//     _coffeeController = AnimationController(vsync: this);
//     _coffeeController.addListener(() {
//       if (_coffeeController.isCompleted) {
//         _coffeeController.stop();
//         copAnimated = true;
//         setState(() {});
//         Future.delayed(const Duration(seconds: 2), () {
//           animateCafeText = true;
//           setState(() {});
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _coffeeController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.green,
//       body: Stack(
//         children: [
//           // White Container top half
//           AnimatedContainer(
//             // duration: const Duration(milliseconds: 5000),
//             duration: const Duration(seconds: 2),
//             height: copAnimated ? screenHeight / 1.9 : screenHeight,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(copAnimated ? 40.0 : 0.0)),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Visibility(
//                   visible: !copAnimated,
//                   child: Lottie.asset(
//                     'asset/plant_animation.json',
//                     controller: _coffeeController,
//                     onLoaded: (composition) {
//                       _coffeeController
//                         ..duration = const Duration(
//                             milliseconds: 5000) // Set duration to 3.5 seconds
//                         ..forward().whenComplete(() {
//                           // Ensure it plays fully
//                           copAnimated = true;
//                           setState(() {});
//                           Future.delayed(const Duration(seconds: 3), () {
//                             if (mounted) {
//                               setState(() {
//                                 animateCafeText = true;
//                               });
//                             }
//                           });
//                         });
//                     },
//                   ),
//                 ),
//                 Visibility(
//                   visible: copAnimated,
//                   child: Image.asset(
//                     'asset/image/plant.png',
//                     height: 250.0,
//                     width: 250.0,
//                   ),
//                 ),
//                 Center(
//                   child: AnimatedOpacity(
//                     opacity: animateCafeText ? 1 : 0,
//                     duration: const Duration(seconds: 2),
//                     child: const Text(
//                       'GREENIFY',
//                       style: TextStyle(fontSize: 50.0, color: Colors.green),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Text bottom part
//           Visibility(visible: copAnimated, child: const _BottomPart()),
//         ],
//       ),
//     );
//   }
// }

// class _BottomPart extends StatelessWidget {
//   const _BottomPart({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Farm to Folk',
//               style: TextStyle(
//                   fontSize: 27.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//             const SizedBox(height: 30.0),
//             Text(
//               'Lorem ipsum dolor sit amet, adipiscing elit. '
//               'Nullam pulvinar dolor sed enim eleifend efficitur.',
//               style: TextStyle(
//                 fontSize: 15.0,
//                 color: Colors.white.withOpacity(0.8),
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 50.0),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 height: 85.0,
//                 width: 85.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2.0),
//                 ),
//                 child: const Icon(
//                   Icons.chevron_right,
//                   size: 50.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plantcare/choose_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.isCompleted) {
        _coffeeController.stop();
        setState(() {
          copAnimated = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            animateCafeText = true;
          });

          // Navigate to ChooseScreen after the animation completes
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChooseScreen()), // Replace with your target screen
              );
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: copAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(copAnimated ? 40.0 : 0.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Only play animation initially
                if (!copAnimated)
                  Lottie.asset(
                    'asset/plant_animation.json',
                    controller: _coffeeController,
                    onLoaded: (composition) {
                      _coffeeController
                        ..duration = const Duration(milliseconds: 3500)
                        ..forward().whenComplete(() {
                          // Animation completed, trigger state change
                          setState(() {
                            copAnimated = true;
                          });
                        });
                    },
                  ),
                if (copAnimated)
                  Image.asset(
                    'asset/image/plant.png',
                    height: 250.0,
                    width: 250.0,
                  ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCafeText ? 1 : 0,
                    duration: const Duration(seconds: 2),
                    child: const Text(
                      'GREENIFY',
                      style: TextStyle(fontSize: 50.0, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom part text
          if (copAnimated) const _BottomPart(),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Farm to Folk',
              style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Lorem ipsum dolor sit amet, adipiscing elit. '
              'Nullam pulvinar dolor sed enim eleifend efficitur.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 85.0,
                width: 85.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.0),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
