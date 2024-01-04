import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style:const TextStyle(fontSize:18)),
          16.height,
          Text(message,style:const TextStyle(fontSize:15)),
          16.height,
        ],
      ),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child:const Text("Si",style:TextStyle(fontSize:20)),
        ),
        TextButton(
          child: const Text("No",style:TextStyle(fontSize:18)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}



