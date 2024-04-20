class Product {
  const Product(
      this.id,
      this.userId,
      this.name,
      this.date,
      this.buyAmount,
      this.buyDate,
      this.buyLocation,
      this.serialId,
      this.imageUrl,
      this.status);

  final String id;
  final String userId;
  final String name;
  final DateTime date;
  final double buyAmount;
  final DateTime buyDate;
  final String buyLocation;
  final String serialId;
  final String imageUrl;
  // In TypeScript, this is called a string union type.
  // It means that the "status" property can only be one of the three strings: 'new', 'pending', or 'complete'.
  final String status;
}
