import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../data/program_data.dart';
import '../../theme/whs_theme.dart';

class ProgramTopicDetailScreen extends StatelessWidget {
  const ProgramTopicDetailScreen({super.key, required this.topic});

  final ProgramTopic topic;

  @override
  Widget build(BuildContext context) {
    final details = <Widget>[
      if (topic.description.trim().isNotEmpty) ...[
        Text(
          topic.description,
          style: const TextStyle(
            color: WhsColors.inkMuted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
      ],
      if (topic.arabicDescription.trim().isNotEmpty) ...[
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            topic.arabicDescription,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: WhsColors.inkMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
      if (topic.date.trim().isNotEmpty)
        _TopicMetadata(label: 'DATE', value: topic.date),
      if (topic.time.trim().isNotEmpty)
        _TopicMetadata(label: 'TIME', value: topic.time),
      if (topic.location.trim().isNotEmpty)
        _TopicMetadata(label: 'LOCATION', value: topic.location),
      if (topic.speakers.isNotEmpty)
        _TopicMetadata(label: 'SPEAKERS', value: topic.speakers.join(' · ')),
    ];

    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth = constraints.maxWidth >= 720
                ? 720.0
                : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 32),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: WhsColors.burgundyDeep,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            AppInfo.eventTitle,
                            style: TextStyle(
                              color: WhsColors.burgundySoft,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'TOPIC ${topic.number.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: WhsColors.teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      topic.title,
                      style: const TextStyle(
                        color: WhsColors.ink,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        topic.arabicTitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: WhsColors.burgundy,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (details.isEmpty) ...[
                      const Divider(color: WhsColors.divider),
                      const SizedBox(height: 16),
                      const Text(
                        'Topic details can be added in the program information source.',
                        style: TextStyle(
                          color: WhsColors.inkMuted,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'يمكن إضافة تفاصيل الموضوع من مصدر معلومات البرنامج.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: WhsColors.inkMuted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Divider(color: WhsColors.divider),
                      const SizedBox(height: 16),
                      ...details,
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopicMetadata extends StatelessWidget {
  const _TopicMetadata({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: WhsColors.teal,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: WhsColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
