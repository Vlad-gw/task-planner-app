import 'package:flutter/material.dart';
import 'package:punctualis_1/styles/colors.dart';
import 'package:punctualis_1/widgets/custom_year_picker.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendar({Key? key, this.initialDate, this.onDateSelected})
    : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Calendar header
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CustomColors.white.color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/icons/filter.png", width: 48, height: 48),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: CustomColors.black.color,
                    ),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(color: CustomColors.purple.color),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    child: Center(
                      child: Text(
                        _getMonthName(_currentMonth.month),
                        style: TextStyle(
                          color: CustomColors.black.color,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: CustomColors.black.color,
                    ),
                    onPressed: () => _changeMonth(1),
                  ),
                  Container(
                    width: 50,
                    height: 40,
                    child: CustomYearPicker(
                      selectedYear: 2025,
                      firstYear: 2010,
                      lastYear: 2030,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildWeekDays(),
            ],
          ),
        ),
        //Calendar body
        Container(
          padding: EdgeInsets.all(8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemCount: _getDaysInMonth() + _getFirstWeekdayOfMonth(),
            itemBuilder: (context, index) {
              if (index < _getFirstWeekdayOfMonth()) {
                return Container(); // Пустые клетки в начале
              }
              final day = index - _getFirstWeekdayOfMonth() + 1;
              final date = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                day,
              );

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        _isSameDay(date, _selectedDate)
                            ? CustomColors.purple.color
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color:
                            _isSameDay(date, _selectedDate)
                                ? Colors.white
                                : Colors.black,
                        fontWeight:
                            _isSameDay(date, DateTime.now())
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: CustomColors.grey.color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children:
            ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: CustomColors.black.color,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta);
    });
  }

  int _getDaysInMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  }

  int _getFirstWeekdayOfMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return months[month - 1];
  }
}
