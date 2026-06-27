import 'package:flutter/material.dart';

import 'google_japan_map_stub.dart'
    if (dart.library.html) 'google_japan_map_web.dart';

void main() {
  runApp(const SyncApp());
}

class SyncApp extends StatelessWidget {
  const SyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYNC.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: SyncColors.voidBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SyncColors.heat,
          brightness: Brightness.dark,
          surface: SyncColors.panel,
        ),
      ),
      home: const SyncShell(),
    );
  }
}

class SyncColors {
  static const voidBlack = Color(0xFF08080A);
  static const panel = Color(0xFF15151A);
  static const panelSoft = Color(0xFF202026);
  static const heat = Color(0xFFFF4D2E);
  static const pulse = Color(0xFFFFB84D);
  static const mint = Color(0xFF80FFD2);
  static const ink = Color(0xFFF6F1E8);
  static const muted = Color(0xFF9B98A5);
}

class SyncShell extends StatefulWidget {
  const SyncShell({super.key});

  @override
  State<SyncShell> createState() => _SyncShellState();
}

class _SyncShellState extends State<SyncShell> {
  int _selectedIndex = 0;
  final List<SyncPost> _posts = [
    const SyncPost(
      author: 'Mika',
      handle: '@mika.run',
      tag: 'morning run',
      text: '今だけ一緒に走れる人を探しています。代々木公園の東側にいます。',
      heat: 92,
      distance: '18m',
    ),
    const SyncPost(
      author: 'Ren',
      handle: '@ren.sound',
      tag: 'live music',
      text: 'このベースライン、近くで同じ熱量の人と話したい。',
      heat: 76,
      distance: '34m',
    ),
  ];

  void _addPost(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _posts.insert(
        0,
        SyncPost(
          author: 'You',
          handle: '@sync.you',
          tag: 'now',
          text: text.trim(),
          heat: 88,
          distance: '0m',
        ),
      );
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(posts: _posts, onPost: _addPost),
      const ChatTab(),
      const SearchTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.78, -0.9),
            radius: 1.2,
            colors: [Color(0xFF3B1711), SyncColors.voidBlack],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const SyncHeader(),
                  Expanded(child: pages[_selectedIndex]),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        height: 70,
        backgroundColor: SyncColors.voidBlack,
        indicatorColor: SyncColors.heat.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            selectedIcon: Icon(Icons.sensors),
            label: 'Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.travel_explore),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SyncHeader extends StatelessWidget {
  const SyncHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/logo.png',
              width: 42,
              height: 42,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYNC.',
                  style: TextStyle(
                    color: SyncColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  '50m以内の熱を検知中',
                  style: TextStyle(color: SyncColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: SyncColors.mint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: SyncColors.mint.withValues(alpha: 0.28),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bluetooth_connected,
                  size: 16,
                  color: SyncColors.mint,
                ),
                SizedBox(width: 6),
                Text(
                  'Live',
                  style: TextStyle(
                    color: SyncColors.mint,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.posts, required this.onPost});

  final List<SyncPost> posts;
  final ValueChanged<String> onPost;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        const PresencePanel(),
        const SizedBox(height: 14),
        Composer(
          controller: _controller,
          onPost: () {
            widget.onPost(_controller.text);
            _controller.clear();
          },
        ),
        const SizedBox(height: 18),
        const SectionTitle(title: 'Near you', action: 'within 50m'),
        const SizedBox(height: 10),
        ...widget.posts.map(
          (post) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SyncPostCard(post: post),
          ),
        ),
      ],
    );
  }
}

class PresencePanel extends StatelessWidget {
  const PresencePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SyncColors.panel.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 116,
            height: 116,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (final ring in const [
                  _Ring(108, 0.08),
                  _Ring(82, 0.16),
                  _Ring(54, 0.28),
                ])
                  Container(
                    width: ring.size,
                    height: ring.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: SyncColors.heat.withValues(alpha: ring.alpha),
                      ),
                    ),
                  ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [SyncColors.heat, SyncColors.pulse],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3つの熱が近くにあります',
                  style: TextStyle(
                    color: SyncColors.ink,
                    fontSize: 20,
                    height: 1.18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '今この場所にいる人だけが見えます。履歴ではなく、現在の感情でつながります。',
                  style: TextStyle(
                    color: SyncColors.muted,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring {
  const _Ring(this.size, this.alpha);

  final double size;
  final double alpha;
}

class Composer extends StatelessWidget {
  const Composer({super.key, required this.controller, required this.onPost});

  final TextEditingController controller;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SyncColors.panelSoft.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            style: const TextStyle(color: SyncColors.ink, fontSize: 15),
            decoration: InputDecoration(
              hintText: '今の熱を投稿する',
              hintStyle: const TextStyle(color: SyncColors.muted),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: SyncColors.muted,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  '共有範囲 50m',
                  style: TextStyle(color: SyncColors.muted, fontSize: 12),
                ),
              ),
              FilledButton.icon(
                onPressed: onPost,
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Post'),
                style: FilledButton.styleFrom(
                  backgroundColor: SyncColors.heat,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: SyncColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(color: SyncColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class SyncPost {
  const SyncPost({
    required this.author,
    required this.handle,
    required this.tag,
    required this.text,
    required this.heat,
    required this.distance,
  });

  final String author;
  final String handle;
  final String tag;
  final String text;
  final int heat;
  final String distance;
}

class SyncPostCard extends StatelessWidget {
  const SyncPostCard({super.key, required this.post});

  final SyncPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SyncColors.panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: SyncColors.heat.withValues(alpha: 0.18),
                foregroundColor: SyncColors.pulse,
                child: Text(post.author.characters.first),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        color: SyncColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${post.handle} / ${post.distance}',
                      style: const TextStyle(
                        color: SyncColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              HeatBadge(value: post.heat),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.text,
            style: const TextStyle(
              color: SyncColors.ink,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PassionChip(label: '#${post.tag}', selected: true),
              const PassionChip(label: '一緒に話す'),
              const PassionChip(label: '保存しない'),
            ],
          ),
        ],
      ),
    );
  }
}

class HeatBadge extends StatelessWidget {
  const HeatBadge({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SyncColors.heat.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$value heat',
        style: const TextStyle(
          color: SyncColors.pulse,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class PassionChip extends StatelessWidget {
  const PassionChip({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? SyncColors.heat.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? SyncColors.heat.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? SyncColors.pulse : SyncColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SimpleTab(
      icon: Icons.chat_bubble,
      title: 'Chat',
      body: '近くで同期した相手との会話がここに表示されます。',
      chips: ['Mika', 'Ren', 'New match'],
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: const [
        JapanHeatMapPanel(),
        SizedBox(height: 14),
        SectionTitle(title: 'Trending in Japan', action: 'live heat'),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PassionChip(label: '#tokyo', selected: true),
            PassionChip(label: '#osaka'),
            PassionChip(label: '#fukuoka'),
            PassionChip(label: '#sapporo'),
            PassionChip(label: '#music'),
            PassionChip(label: '#startup'),
          ],
        ),
      ],
    );
  }
}

class JapanHeatMapPanel extends StatelessWidget {
  const JapanHeatMapPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SyncColors.panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.map_outlined, color: SyncColors.pulse, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Japan heat map',
                      style: TextStyle(
                        color: SyncColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '日本中の今の熱を俯瞰',
                      style: TextStyle(color: SyncColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              HeatBadge(value: 84),
            ],
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 1.2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: const GoogleJapanMap(),
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _MapMetric(label: 'Tokyo', value: '96'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MapMetric(label: 'Osaka', value: '78'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MapMetric(label: 'Fukuoka', value: '69'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapMetric extends StatelessWidget {
  const _MapMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: SyncColors.muted, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: SyncColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: SyncColors.panel,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/ui.png',
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@sync.you',
                      style: TextStyle(
                        color: SyncColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '数字ではなく、今いる場所と熱でつながるプロフィール。',
                      style: TextStyle(
                        color: SyncColors.muted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SectionTitle(title: 'Passion graph', action: '7 days'),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PassionChip(label: '#product', selected: true),
            PassionChip(label: '#music'),
            PassionChip(label: '#event'),
            PassionChip(label: '#run'),
          ],
        ),
      ],
    );
  }
}

class _SimpleTab extends StatelessWidget {
  const _SimpleTab({
    required this.icon,
    required this.title,
    required this.body,
    required this.chips,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: SyncColors.panel,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: SyncColors.pulse, size: 34),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: SyncColors.ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: const TextStyle(
                  color: SyncColors.muted,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: chips
                    .map((chip) => PassionChip(label: '#$chip'))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
