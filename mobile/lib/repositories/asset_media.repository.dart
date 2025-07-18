import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/domain/models/exif.model.dart';
import 'package:immich_mobile/domain/models/store.model.dart';
import 'package:immich_mobile/entities/asset.entity.dart';
import 'package:immich_mobile/entities/store.entity.dart';
import 'package:immich_mobile/utils/hash.dart';
import 'package:photo_manager/photo_manager.dart' hide AssetType;

final assetMediaRepositoryProvider = Provider((ref) => AssetMediaRepository());

class AssetMediaRepository {
  Future<List<String>> deleteAll(List<String> ids) =>
      PhotoManager.editor.deleteWithIds(ids);

  Future<Asset?> get(String id) async {
    final entity = await AssetEntity.fromId(id);
    return toAsset(entity);
  }

  static Asset? toAsset(AssetEntity? local) {
    if (local == null) return null;
    final Asset asset = Asset(
      checksum: "",
      localId: local.id,
      ownerId: fastHash(Store.get(StoreKey.currentUser).id),
      fileCreatedAt: local.createDateTime,
      fileModifiedAt: local.modifiedDateTime,
      updatedAt: local.modifiedDateTime,
      durationInSeconds: local.duration,
      type: AssetType.values[local.typeInt],
      fileName: local.title!,
      width: local.width,
      height: local.height,
      isFavorite: local.isFavorite,
    );
    if (asset.fileCreatedAt.year == 1970) {
      asset.fileCreatedAt = asset.fileModifiedAt;
    }
    if (local.latitude != null) {
      asset.exifInfo =
          ExifInfo(latitude: local.latitude, longitude: local.longitude);
    }
    asset.local = local;
    return asset;
  }

  Future<String?> getOriginalFilename(String id) async {
    final entity = await AssetEntity.fromId(id);

    if (entity == null) {
      return null;
    }

    // titleAsync gets the correct original filename for some assets on iOS
    // otherwise using the `entity.title` would return a random GUID
    return await entity.titleAsync;
  }
}
