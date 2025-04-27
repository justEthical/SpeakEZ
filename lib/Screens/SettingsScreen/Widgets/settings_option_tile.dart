import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsOptionTile extends StatefulWidget {
  final String icon;
  final String heading;
  final String content;
  final onTap;
  const SettingsOptionTile({
    super.key,
    this.heading = "",
    required this.content,
    required this.icon,
    required this.onTap,
  });

  @override
  State<SettingsOptionTile> createState() => _SettingsOptionTileState();
}

class _SettingsOptionTileState extends State<SettingsOptionTile> {
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
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(widget.icon, color: Colors.white),
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
                              ),
                            ),
                        const SizedBox(height: 5),
                        Text(
                          widget.content,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
