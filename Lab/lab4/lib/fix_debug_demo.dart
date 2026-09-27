import 'package:flutter/material.dart';

// Exercise 5 - Debug & Fix Common UI Errors
// Each fix below is shown as BEFORE (buggy) vs AFTER (fixed),
// with a short explanation in the comment.

/// ---------------------------------------------------------------
/// FIX 1: ListView inside Column → wrap with Expanded
/// ---------------------------------------------------------------
/// BEFORE (crashes: "Vertical viewport was given unbounded height"):
///
/// Column(
///   children: [
///     Text('Header'),
///     ListView.builder(              // <- has no bounded height
///       itemCount: 20,
///       itemBuilder: (c, i) => ListTile(title: Text('Item $i')),
///     ),
///   ],
/// )
///
/// AFTER: Expanded gives the ListView the remaining bounded space
/// inside the Column, so it knows how tall it can be.
class Fix1ListViewInColumn extends StatelessWidget {
  const Fix1ListViewInColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Header'),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------
/// FIX 2: Overflow on small screens → SingleChildScrollView
/// ---------------------------------------------------------------
/// BEFORE (yellow/black "RenderFlex overflowed" stripes on small
/// screens or when the keyboard opens):
///
/// Column(
///   children: [
///     Image.asset('big_banner.png'),
///     Text('Title'),
///     Text('Long description...'),
///     ElevatedButton(onPressed: () {}, child: Text('Submit')),
///   ],
/// )
///
/// AFTER: wrap the Column in SingleChildScrollView so content that
/// doesn't fit the viewport scrolls instead of overflowing.
class Fix2Overflow extends StatelessWidget {
  const Fix2Overflow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'big_banner.png',
            errorBuilder: (c, e, s) =>
                const SizedBox(height: 300, child: Placeholder()),
          ),
          const Text('Title', style: TextStyle(fontSize: 24)),
          for (int i = 0; i < 15; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Long description... line repeated to overflow the screen.',
              ),
            ),
          ElevatedButton(onPressed: () {}, child: const Text('Submit')),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// FIX 3: UI not updating → add setState()
/// ---------------------------------------------------------------
/// BEFORE (counter variable changes but UI never redraws):
///
/// int count = 0;
/// onPressed: () {
///   count++;           // <- mutated, but Flutter doesn't know to rebuild
/// }
///
/// AFTER: setState() tells the framework this widget's state changed,
/// which schedules a rebuild.
class Fix3SetState extends StatefulWidget {
  const Fix3SetState({super.key});

  @override
  State<Fix3SetState> createState() => _Fix3SetStateState();
}

class _Fix3SetStateState extends State<Fix3SetState> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $count', style: const TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------
/// FIX 4: DatePicker "context" error → call from a widget's own
/// build context, not from a global/static context or before the
/// widget is mounted.
/// ---------------------------------------------------------------
/// BEFORE (throws "Navigator operation requested with a context
/// that does not include a Navigator", often from calling it inside
/// initState() or with a stale/outer context):
///
/// void initState() {
///   super.initState();
///   showDatePicker(context: context, ...);  // <- context not ready yet
/// }
///
/// AFTER: trigger it from an event handler (e.g. button onPressed)
/// using the BuildContext of the widget that is already in the tree,
/// and check `mounted` before using the result after the await.
class Fix4DatePicker extends StatefulWidget {
  const Fix4DatePicker({super.key});

  @override
  State<Fix4DatePicker> createState() => _Fix4DatePickerState();
}

class _Fix4DatePickerState extends State<Fix4DatePicker> {
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          selectedDate == null
              ? 'No date selected'
              : 'Selected: ${selectedDate!.toLocal().toString().split(' ')[0]}',
        ),
        ElevatedButton(
          onPressed: () =>
              _pickDate(context), // called from a live build context
          child: const Text('Pick Date'),
        ),
      ],
    );
  }
}
