import 'package:flutter/material.dart';

class ButtonLink extends StatelessWidget {
  const ButtonLink({
    super.key,
    required this.title,
    required this.subTitle,
    required this.screen,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final Widget screen;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 238, 246, 255),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        color: Color.fromARGB(225, 14, 20, 69),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 134, 133, 133),
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 35,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
