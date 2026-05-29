import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [

            /// 顶部栏
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),

              child: Row(
                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "正在播放",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 专辑封面
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),

                child: Image.network(
                  "https://picsum.photos/500",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 歌曲信息
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),

              child: Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          "晴天",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "周杰伦",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    CupertinoIcons.heart,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                children: [

                  Slider(
                    value: 0.3,
                    onChanged: (value) {},
                  ),

                  const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "1:24",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      Text(
                        "4:32",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 控制按钮
            Padding(
              padding: const EdgeInsets.only(bottom: 50),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  IconButton(
                    onPressed: () {},

                    iconSize: 36,

                    icon: const Icon(
                      CupertinoIcons.backward_fill,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Container(
                    width: 82,
                    height: 82,

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      onPressed: () {},

                      iconSize: 42,

                      icon: const Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  IconButton(
                    onPressed: () {},

                    iconSize: 36,

                    icon: const Icon(
                      CupertinoIcons.forward_fill,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}