import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResultTile extends StatefulWidget {
  final String icon;
  final String heading;
  final String content;
  final double padding;
  final onTap;
  const ResultTile({
    super.key,
    this.heading = "",
    required this.content,
    required this.icon,
    required this.onTap,
    this.padding = 0,
  });

  @override
  State<ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Divider(thickness: 1, color: Colors.grey),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 5),
                            color: Colors.indigoAccent,
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(widget.padding),
                      child: SvgPicture.asset(
                        widget.icon,
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.heading == ''
                            ? const SizedBox()
                            : Text(
                              widget.heading,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.deepPurple
                              ),
                            ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: Get.width - 120,
                          child: Text(
                            widget.content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
