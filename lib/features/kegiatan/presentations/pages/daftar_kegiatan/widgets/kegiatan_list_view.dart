import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../data/models/kegiatan_model.dart';
import '../../widgets/kegiatan_card.dart';
import 'load_more_footer.dart';

class KegiatanListView extends StatefulWidget {
  final List<KegiatanModel> items;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const KegiatanListView({
    super.key,
    required this.items,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  State<KegiatanListView> createState() => _KegiatanListViewState();
}

class _KegiatanListViewState extends State<KegiatanListView> {
  late final ScrollController _scrollController;

  static const double _loadMoreThreshold = 0.8;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * _loadMoreThreshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: AnimationLimiter(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == widget.items.length) {
              return const LoadMoreFooter();
            }

            final kegiatan = widget.items[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: KegiatanCard(
                    kegiatan: kegiatan,
                    onTap: () {},
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}