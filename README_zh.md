# pure_route_aware

[![pub package](https://img.shields.io/pub/v/pure_route_aware.svg)](https://pub.dev/packages/pure_route_aware)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

一个**纯净**的 Flutter 路由可见性监听方案，**不会触发 widget 重建**。

## 问题背景

使用 Flutter 官方的 `RouteAware` 和 `RouteObserver` 时，需要调用 `ModalRoute.of(context)` 获取当前路由。但 `ModalRoute.of(context)` 会创建 `InheritedWidget` 依赖，导致 widget 在路由状态变化时**重新构建**。

## 解决方案

`pure_route_aware` 使用 `ModalRoute.settingsOf(context)` 替代，只读取路由设置而不创建依赖。实现相同的回调功能，但没有性能开销。

## 特性

- ✅ **无重建副作用** - 使用 `ModalRoute.settingsOf()` 而非 `ModalRoute.of()`
- ✅ **简洁 API** - 只有 2 个核心回调：`didPushNext`、`didPopNext`
- ✅ **自动过滤弹窗** - Dialog 和 BottomSheet 不会触发回调
- ✅ **支持多监听者** - 同一路由可注册多个监听器
- ✅ **使用简单** - 只需一个 mixin 和一个 observer，无需手动订阅/取消订阅

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  pure_route_aware: ^1.0.0
```

## 使用方法

### 1. 注册 Observer

在 `MaterialApp` 中添加 `PureRouteObserver`：

```dart
import 'package:pure_route_aware/pure_route_aware.dart';

MaterialApp(
  navigatorObservers: [PureRouteObserver()],
  // ...
)
```

### 2. 在页面中使用 Mixin

**简单方式（推荐）：**

```dart
import 'package:pure_route_aware/pure_route_aware.dart';

class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
  @override
  void onRouteVisibilityChanged(bool visible) {
    if (visible) {
      // 页面可见 - 恢复视频播放、刷新数据等
      videoController.play();
    } else {
      // 页面隐藏 - 暂停视频、停止动画等
      videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) => ...;
}
```

**或者使用分开的回调：**

```dart
class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
  @override
  void didPushNext() {
    super.didPushNext();
    videoController.pause();  // 页面被覆盖
  }

  @override
  void didPopNext() {
    super.didPopNext();
    videoController.play();  // 页面重新可见
  }

  @override
  Widget build(BuildContext context) => ...;
}
```

### 3. 检查可见性状态

也可以主动检查当前页面是否可见：

```dart
class _MyPageState extends State<MyPage> with PureRouteAwareMixin<MyPage> {
  void someMethod() {
    if (isRouteVisible) {
      // 仅在页面可见时执行
    }
  }
}
```

## API 参考

### PureRouteObserver

一个 `NavigatorObserver`，用于追踪路由变化并通知已注册的页面。

### PureRouteAwareMixin

为 `State` 类提供路由可见性回调的 mixin：

| 属性/方法 | 说明 |
|----------|------|
| `isRouteVisible` | 当前页面是否可见 |
| `onRouteVisibilityChanged(bool)` | 可见性变化回调（推荐使用）|
| `didPushNext()` | 页面被新路由覆盖时调用 |
| `didPopNext()` | 上层路由关闭、页面重新可见时调用 |

### PureRouteRegistry

内部注册表，用于管理路由与 widget 的映射关系。通常不需要直接使用。

## 与官方 RouteAware 对比

| 特性 | RouteAware | PureRouteAwareMixin |
|-----|------------|---------------------|
| 需要 `ModalRoute.of()` | 是 | 否 |
| 会触发重建 | 是 | 否 |
| 需要手动订阅/取消订阅 | 是 | 否（自动）|
| 弹窗过滤 | 需手动处理 | 自动过滤 |
| 多监听者支持 | 复杂 | 内置支持 |

## 许可证

MIT License - 详见 [LICENSE](LICENSE)

