import 'package:flutter/material.dart';

// Exercise 5 - Debug & Fix Common UI Errors
//
// BEFORE and AFTER share the SAME class name, so main.dart never changes.
// Only one version of each class can be active at a time:
//   - Default: AFTER (fixed) is active, BEFORE (buggy) is commented out.
//   - To see the bug: comment out the AFTER class, uncomment the BEFORE class.

/// ---------------------------------------------------------------
/// FIX 1: ListView inside Column → wrap with Expanded
/// ---------------------------------------------------------------

// // ----- BEFORE (crashes: "Vertical viewport was given unbounded height") -----
// class Fix1ListViewInColumn extends StatelessWidget {
//   const Fix1ListViewInColumn({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text('Header'),
//         ListView.builder(              // <- has no bounded height
//           itemCount: 20,
//           itemBuilder: (c, i) => ListTile(title: Text('Item $i')),
//         ),
//       ],
//     );
//   }
// }

// ----- AFTER -----
// Expanded gives the ListView the remaining bounded space inside the
// Column, so it knows how tall it can be.
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

// ----- BEFORE (yellow/black "RenderFlex overflowed" stripes) -----
// (uses Placeholder instead of Image.asset so no asset file is needed)
// class Fix2Overflow extends StatelessWidget {
//   const Fix2Overflow({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(height: 300, child: Placeholder()),
//           const Text('Title', style: TextStyle(fontSize: 24)),
//           for (int i = 0; i < 30; i++)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 4),
//               child: Text(
//                 'Long description... line repeated to overflow the screen.',
//               ),
//             ),
//           ElevatedButton(onPressed: () {}, child: const Text('Submit')),
//         ],
//       ),
//     );
//   }
// }

// ----- AFTER -----
// Wrap the Column in SingleChildScrollView so content that doesn't fit
// the viewport scrolls instead of overflowing.
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
          for (int i = 0; i < 30; i++)
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

// ----- BEFORE (counter variable changes but UI never redraws) -----
// class Fix3SetState extends StatefulWidget {
//   const Fix3SetState({super.key});
//
//   @override
//   State<Fix3SetState> createState() => _Fix3SetStateState();
// }
//
// class _Fix3SetStateState extends State<Fix3SetState> {
//   int count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Count: $count', style: const TextStyle(fontSize: 24)),
//         ElevatedButton(
//           onPressed: () {
//             count++; // <- mutated, but Flutter doesn't know to rebuild
//             debugPrint('count = $count'); // console shows the value did change
//           },
//           child: const Text('Increment'),
//         ),
//       ],
//     );
//   }
// }

// ----- AFTER -----
// setState() tells the framework this widget's state changed,
// which schedules a rebuild.
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
/// FIX 4: DatePicker "context" error → call from an event handler
/// using the widget's own build context, not from initState().
/// ---------------------------------------------------------------

// ----- BEFORE (context error: showDatePicker called inside initState()
// before the context is ready; run in debug mode) -----
// class Fix4DatePicker extends StatefulWidget {
//   const Fix4DatePicker({super.key});
//
//   @override
//   State<Fix4DatePicker> createState() => _Fix4DatePickerState();
// }
//
// class _Fix4DatePickerState extends State<Fix4DatePicker> {
//   @override
//   void initState() {
//     super.initState();
//     showDatePicker(
//       context: context, // <- context not ready yet
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Opening this page throws a context error'));
//   }
// }

// ----- AFTER -----
// Trigger it from an event handler (e.g. button onPressed) using the
// BuildContext of the widget already in the tree, and check `mounted`
// before using the result after the await.
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