import 'package:flutter/material.dart';



class CustomLikeButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLiked;
  final int likeCount;

  const CustomLikeButton({
    required this.onTap,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  _CustomLikeButtonState createState() => _CustomLikeButtonState();
}

class _CustomLikeButtonState extends State<CustomLikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
  }

  void _handleTap() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
          ),
          Text(
            _likeCount.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
