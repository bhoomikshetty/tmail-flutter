
import 'package:collection/collection.dart';
import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:model/email/attachment.dart';

extension ListAttachmentExtension on List<Attachment> {

  num totalSize() {
    if (isNotEmpty) {
      final currentListSize = map((attachment) => attachment.size?.value ?? 0).toList();
      final totalSize = currentListSize.reduce((sum, size) => sum + size);
      return totalSize;
    }
    return 0;
  }

  List<Attachment> getListAttachmentsDisplayedOutside(List<Attachment>? htmlBodyAttachments) {
    return where((attachment) => _validateOutsideAttachment(attachment, htmlBodyAttachments)).toList();
  }

  bool _validateOutsideAttachment(Attachment attachment, List<Attachment>? htmlBodyAttachments) {
    final result = (attachment.noCid() || !attachment.isInlined()) && (htmlBodyAttachments == null || !htmlBodyAttachments._include(attachment));
    return result;
  }

  bool _include(Attachment newAttachment) {
    final matchedAttachment = firstWhereOrNull((attachment) => attachment.blobId == newAttachment.blobId);
    return matchedAttachment != null;
  }

  List<Attachment> get listAttachmentsDisplayedInContent => where((attachment) => attachment.hasCid()).toList();

  Map<String, String> toMapCidImageDownloadUrl({
    required AccountId accountId,
    required String downloadUrl
  }) {
    final mapUrlDownloadCID = {
      for (var attachment in listAttachmentsDisplayedInContent)
        attachment.cid! : attachment.getDownloadUrl(downloadUrl, accountId)
    };
    return mapUrlDownloadCID;
  }
}