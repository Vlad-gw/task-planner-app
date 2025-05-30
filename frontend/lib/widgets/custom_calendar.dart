import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Color? headerColor;
  final Color? selectedColor;

  const CustomCalendar({
    Key? key,
    this.initialDate,
    this.onDateSelected,
    this.headerColor = Colors.deepPurple,
    this.selectedColor = Colors.deepPurple,
  }) : super(key: key);

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
        // Кастомная шапка
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.headerColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildWeekDays(),
            ],
          ),
        ),
        // Тело календаря
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
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
              final date = DateTime(_currentMonth.year, _currentMonth.month, day);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _isSameDay(date, _selectedDate)
                        ? widget.selectedColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: _isSameDay(date, _selectedDate)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: _isSameDay(date, DateTime.now())
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
    return Row(
      children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        );
      }).toList(),
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
      'Январь', 'Февраль', 'Март', 'Апрель', 'ЫЫА', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
}