import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/get_task_by_id_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase getTasksUseCase;
  final GetTaskByIdUseCase getTaskByIdUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;

  int _currentPage = 1;
  static const int _pageSize = 20;
  List<TaskEntity> _allTasks = [];
  bool _isLoading = false;

  TasksBloc({
    required this.getTasksUseCase,
    required this.getTaskByIdUseCase,
    required this.updateTaskStatusUseCase,
  }) : super(const TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadNextPage>(_onLoadNextPage);
    on<RefreshTasks>(_onRefreshTasks);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TasksState> emit,
  ) async {
    if (_isLoading) return;
    _isLoading = true;
    _currentPage = 1;
    _allTasks = [];

    emit(const TasksLoading());

    final result = await getTasksUseCase(
      GetTasksParams(page: _currentPage, pageSize: _pageSize),
    );

    result.fold(
      (failure) {
        _isLoading = false;
        emit(TasksError(message: failure.message));
      },
      (paginatedResponse) {
        _allTasks = paginatedResponse.items;
        _isLoading = false;

        final completedCount =
            _allTasks.where((task) => task.completed).length;
        final pendingCount = _allTasks.where((task) => !task.completed).length;

        emit(TasksLoaded(
          tasks: _allTasks,
          currentPage: paginatedResponse.currentPage,
          hasNextPage: paginatedResponse.hasNextPage,
          totalPages: paginatedResponse.totalPages,
          completedCount: completedCount,
          pendingCount: pendingCount,
        ));
      },
    );
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded || _isLoading) return;

    final currentState = state as TasksLoaded;
    if (!currentState.hasNextPage) return;

    _isLoading = true;
    _currentPage++;

    emit(TasksLoadingMore(
      tasks: currentState.tasks,
      currentPage: currentState.currentPage,
      hasNextPage: currentState.hasNextPage,
      totalPages: currentState.totalPages,
      completedCount: currentState.completedCount,
      pendingCount: currentState.pendingCount,
    ));

    final result = await getTasksUseCase(
      GetTasksParams(page: _currentPage, pageSize: _pageSize),
    );

    result.fold(
      (failure) {
        _isLoading = false;
        _currentPage--;
        emit(TasksError(
          message: failure.message,
          previousTasks: currentState.tasks,
        ));
      },
      (paginatedResponse) {
        _allTasks.addAll(paginatedResponse.items);
        _isLoading = false;

        final completedCount =
            _allTasks.where((task) => task.completed).length;
        final pendingCount = _allTasks.where((task) => !task.completed).length;

        emit(TasksLoaded(
          tasks: _allTasks,
          currentPage: paginatedResponse.currentPage,
          hasNextPage: paginatedResponse.hasNextPage,
          totalPages: paginatedResponse.totalPages,
          completedCount: completedCount,
          pendingCount: pendingCount,
        ));
      },
    );
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TasksState> emit,
  ) async {
    if (_isLoading) return;
    _isLoading = true;
    _currentPage = 1;
    _allTasks = [];

    final result = await getTasksUseCase(
      GetTasksParams(page: _currentPage, pageSize: _pageSize),
    );

    result.fold(
      (failure) {
        _isLoading = false;
        emit(TasksError(message: failure.message));
      },
      (paginatedResponse) {
        _allTasks = paginatedResponse.items;
        _isLoading = false;

        final completedCount =
            _allTasks.where((task) => task.completed).length;
        final pendingCount = _allTasks.where((task) => !task.completed).length;

        emit(TasksLoaded(
          tasks: _allTasks,
          currentPage: paginatedResponse.currentPage,
          hasNextPage: paginatedResponse.hasNextPage,
          totalPages: paginatedResponse.totalPages,
          completedCount: completedCount,
          pendingCount: pendingCount,
        ));
      },
    );
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;

    final result = await updateTaskStatusUseCase(
      UpdateTaskStatusParams(
        id: event.taskId,
        completed: event.completed,
      ),
    );

    result.fold(
      (failure) {
        emit(TasksError(
          message: 'Ошибка обновления статуса',
          previousTasks: currentState.tasks,
        ));
      },
      (updatedTask) {
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.taskId) {
            return updatedTask;
          }
          return task;
        }).toList();

        final completedCount =
            updatedTasks.where((task) => task.completed).length;
        final pendingCount =
            updatedTasks.where((task) => !task.completed).length;

        _allTasks = updatedTasks;

        emit(TaskStatusUpdated(
          tasks: updatedTasks,
          completedCount: completedCount,
          pendingCount: pendingCount,
          message: event.completed
              ? 'Задача отмечена как выполненная ✓'
              : 'Задача отмечена как невыполненная',
        ));

        emit(TasksLoaded(
          tasks: updatedTasks,
          currentPage: currentState.currentPage,
          hasNextPage: currentState.hasNextPage,
          totalPages: currentState.totalPages,
          completedCount: completedCount,
          pendingCount: pendingCount,
        ));
      },
    );
  }
}
