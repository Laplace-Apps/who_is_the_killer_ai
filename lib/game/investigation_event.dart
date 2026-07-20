class InvestigationEvent {
  const InvestigationEvent({
    required this.type,
    this.suspectId,
    this.clueId,
    this.roomId,
    this.prompt,
    this.x,
    this.y,
  });

  factory InvestigationEvent.tapSuspect(String suspectId) => InvestigationEvent(
        type: InvestigationEventType.tapSuspect,
        suspectId: suspectId,
      );

  factory InvestigationEvent.discoverClue(String clueId) => InvestigationEvent(
        type: InvestigationEventType.discoverClue,
        clueId: clueId,
      );

  factory InvestigationEvent.enterRoom(String roomId) => InvestigationEvent(
        type: InvestigationEventType.enterRoom,
        roomId: roomId,
      );

  factory InvestigationEvent.proximity(String? prompt) => InvestigationEvent(
        type: InvestigationEventType.proximity,
        prompt: prompt,
      );

  factory InvestigationEvent.playerMoved(double x, double y) =>
      InvestigationEvent(
        type: InvestigationEventType.playerMoved,
        x: x,
        y: y,
      );

  final InvestigationEventType type;
  final String? suspectId;
  final String? clueId;
  final String? roomId;
  final String? prompt;
  final double? x;
  final double? y;
}

enum InvestigationEventType {
  tapSuspect,
  discoverClue,
  enterRoom,
  proximity,
  playerMoved,
}
