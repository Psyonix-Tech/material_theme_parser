import 'package:flutter/material.dart';

class WidgetsExample extends StatelessWidget {
  const WidgetsExample({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget title(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '$title :',
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title('Text'),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Head line 1',
                    style: Theme.of(context).textTheme.headline1),
                Text('Head line 2',
                    style: Theme.of(context).textTheme.headline2),
                Text('Head line 3',
                    style: Theme.of(context).textTheme.headline3),
                Text('Head line 4',
                    style: Theme.of(context).textTheme.headline4),
                Text('Head line 5',
                    style: Theme.of(context).textTheme.headline5),
                Text('Head line 6',
                    style: Theme.of(context).textTheme.headline6),
                Text('Subtitle 1',
                    style: Theme.of(context).textTheme.subtitle1),
                Text('Subtitle 2',
                    style: Theme.of(context).textTheme.subtitle2),
                Text('Button', style: Theme.of(context).textTheme.button),
                Text('Caption', style: Theme.of(context).textTheme.caption),
                Text('overline', style: Theme.of(context).textTheme.overline),
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: e,
                      ))
                  .toList(),
            ),
            const Divider(),
            title('Buttons'),
            Wrap(
              alignment: WrapAlignment.start,
              clipBehavior: Clip.none,
              runSpacing: 8.0,
              spacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('ElevatedButton'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('OutlinedButton'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('TextButton'),
                ),
                const BackButton(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                const CloseButton(),
                FloatingActionButton(
                  onPressed: () {},
                  heroTag: 'FloatingActionButton',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.extended(
                  onPressed: () {},
                  heroTag: 'FloatingActionButton.extended',
                  icon: const Icon(Icons.add),
                  label: const Text('FloatingActionButton.extended'),
                ),
                FloatingActionButton.large(
                  onPressed: () {},
                  heroTag: 'FloatingActionButton.large',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.small(
                  onPressed: () {},
                  heroTag: 'FloatingActionButton.large',
                  child: const Icon(Icons.add),
                ),
                TextSelectionToolbarTextButton(
                  child: const Text('TextSelectionToolbarTextButton'),
                  padding: TextSelectionToolbarTextButton.getPadding(1, 4),
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(),
            title('Value Buttons'),
            const ValueButtons(),
            title('Sliders'),
            const Sliders(),
            title('Text Field'),
            TextFormField(
              initialValue: 'Type error for error',
              decoration: const InputDecoration(
                suffix: Icon(Icons.search),
                suffixIcon: Icon(Icons.search),
                labelText: 'Text Field Label',
                hintText: 'Text Field Hint',
                helperText: 'Text Field Helper',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (str) =>
                  str?.toLowerCase() == 'error' ? 'Text Field Error' : null,
            ),
            const Divider(),
            title('Bottom Navigation Bar'),
            const SizedBox(height: 16.0),
            BottomNavigationBar(
              items: const [
                Icon(Icons.screen_rotation_outlined),
                Icon(Icons.security_update_good),
                Icon(Icons.send_rounded),
              ]
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e,
                      label: 'Title',
                    ),
                  )
                  .toList(),
            ),
            title('Surfaces'),
            Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: [
                _SurfaceView(
                  color: Theme.of(context).colorScheme.background,
                  name: 'Background',
                ),
                _SurfaceView(
                  color: Theme.of(context).colorScheme.surface,
                  name: 'Surface',
                ),
                _SurfaceView(
                  color: Theme.of(context).colorScheme.background,
                  name: 'background',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ValueButtons extends StatefulWidget {
  const ValueButtons({Key? key}) : super(key: key);

  @override
  _ValueButtonsState createState() => _ValueButtonsState();
}

class _ValueButtonsState extends State<ValueButtons> {
  bool value = false;
  String? selectedValue;
  void reversedOnChanged(value) => onChanged(!value);
  void onChanged(value) {
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Expanded(child: Text('DropDownButton')),
            Expanded(
              child: DropdownButton<String>(
                items: ['Material Design', 'IOS Cupertino', 'Awesome Design']
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                hint: const Text('Hint Text'),
                value: selectedValue,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Switch(value: value, onChanged: onChanged),
            Radio(value: true, groupValue: value, onChanged: onChanged),
            Checkbox(value: value, onChanged: onChanged),
          ],
        ),
        SwitchListTile(
            title: const Text('SwitchListTile title'),
            subtitle: const Text('SwitchListTile subtitle'),
            value: !value,
            onChanged: reversedOnChanged),
        RadioListTile(
            title: const Text('RadioListTile title'),
            subtitle: const Text('RadioListTile subtitle'),
            value: false,
            groupValue: value,
            onChanged: reversedOnChanged),
        CheckboxListTile(
            title: const Text('CheckboxListTile title'),
            subtitle: const Text('CheckboxListTile subtitle'),
            value: !value,
            onChanged: reversedOnChanged),
      ],
    );
  }
}

class Sliders extends StatefulWidget {
  const Sliders({Key? key}) : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  double sliderValue = 50;
  RangeValues rangeValue = const RangeValues(25, 75);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: sliderValue,
          min: 0.0,
          max: 100.0,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
          },
        ),
        RangeSlider(
            min: 0.0,
            max: 100.0,
            values: rangeValue,
            onChanged: (value) {
              setState(() {
                rangeValue = value;
              });
            })
      ],
    );
  }
}

class _SurfaceView extends StatelessWidget {
  final Color color;
  final String name;
  const _SurfaceView({
    Key? key,
    required this.color,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(name),
        ),
        Container(
          height: 150,
          width: 300,
          color: color,
        ),
      ],
    );
  }
}
