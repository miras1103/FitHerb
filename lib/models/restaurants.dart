class Item {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
class Review {
  final String name;
  final String text;
  final String imageUrl;

  Review({
    required this.name,
    required this.text,
    required this.imageUrl,
  });
}


class Restaurants {
  String id;
  String name;
  String address;
  String attributes;
  String imageUrl;
  String imageCredits;
  double distance;
  double rating;
  List<Item> items;
  List<Review> reviews;

  Restaurants(
      this.id,
      this.name,
      this.address,
      this.attributes,
      this.imageUrl,
      this.imageCredits,
      this.distance,
      this.rating,
      this.items,
      this.reviews
      );


  String getRatingAndDistance() {
    return '''Rating: ${rating.toStringAsFixed(1)} ★ | Distance: ${distance.toStringAsFixed(1)} miles''';
  }
}

List<Restaurants> restaurants = [
  Restaurants(
      '0',
      'Vitamin A',
      'Vision Support',
      'Supports eye health and immune function',
      'assets/restaurants/vitamina.jpg',
      'https://images.unsplash.com/photo-1584367369853-8d6a0c8c3c92?auto=format&fit=crop&w=800&q=80',
      0.5,
      4.8,
      [
        Item(
          name: 'Vitamin A Capsules',
          description:
          '''Supports vision, skin health, and immune system. Ideal for daily supplementation.''',
          price: 8.99,
          imageUrl: 'assets/restaurants/vitamina1.jpg',
        ),
        Item(
          name: 'Vitamin A Gummies',
          description:
          '''Tasty chewable gummies that promote healthy eyesight and skin.''',
          price: 10.99,
          imageUrl: 'assets/restaurants/vitamina2.jpg',
        ),
        Item(
          name: 'Liquid Vitamin A Drops',
          description:
          '''Easy-to-absorb liquid drops for quick vitamin intake.''',
          price: 12.49,
          imageUrl: 'assets/restaurants/vitamina3.jpg',
        ),
        Item(
          name: 'Vitamin A + D Complex',
          description:
          '''Combination of vitamins A and D for stronger immunity and bone support.''',
          price: 14.99,
          imageUrl: 'assets/restaurants/vitamina4.jpg',
        ),
        Item(
          name: 'Organic Vitamin A Softgels',
          description:
          '''Natural source of vitamin A derived from organic ingredients.''',
          price: 11.99,
          imageUrl: 'assets/restaurants/vitamina5.png',
        ),
      ],[
    Review(
      name: 'Arman',
      text: 'Really improved my vision ',
      imageUrl: 'assets/profile_pics/person_cesare.jpeg',
    ),
    Review(
      name: 'Dias',
      text: 'Good quality, will buy again',
      imageUrl: 'assets/profile_pics/person_crispy.png',
    ),
    Review(
      name: 'Nurlan',
      text: 'Works well for daily use',
      imageUrl: 'assets/profile_pics/person_joe.jpeg',
    ),
    Review(
      name: 'Bekzat',
      text: 'Nice product, fast effect',
      imageUrl: 'assets/profile_pics/person_katz.jpeg',
    ),
    Review(
      name: 'Ayan',
      text: 'Affordable and healthy',
      imageUrl: 'assets/profile_pics/person_kelvin.jpg',
    ),
  ]
  ),
  Restaurants(
      '1',
      'Vitamin B',
      'Energy Support',
      'Boosts energy levels and supports metabolism',
      'assets/restaurants/vitaminb.jpg',
      'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=800&q=80',
      0.7,
      4.7,
      [
        Item(
          name: 'Vitamin B Complex',
          description:
          '''Supports metabolism, improves energy levels, and helps reduce fatigue.''',
          price: 10.99,
          imageUrl: 'assets/restaurants/vitaminb1.png',
        ),
        Item(
          name: 'Vitamin B12 Tablets',
          description:
          '''Essential for nerve function and red blood cell formation.''',
          price: 9.49,
          imageUrl: 'assets/restaurants/vitaminb2.jpg',
        ),
        Item(
          name: 'Vitamin B Gummies',
          description:
          '''Delicious chewable vitamins for daily energy support.''',
          price: 11.99,
          imageUrl: 'assets/restaurants/vitaminb3.jpg',
        ),
        Item(
          name: 'B-Complex Liquid',
          description:
          '''Fast-absorbing liquid formula for quick energy boost.''',
          price: 13.99,
          imageUrl: 'assets/restaurants/vitaminb4.png',
        ),
        Item(
          name: 'Vitamin B + Magnesium',
          description:
          '''Supports muscle function, reduces stress, and boosts energy.''',
          price: 12.49,
          imageUrl: 'assets/restaurants/vitaminb5.jpg',
        ),
      ],[
    Review(
      name: 'Ruslan',
      text: 'Energy level increased ',
      imageUrl: 'assets/profile_pics/person_manda.png',
    ),
    Review(
      name: 'Timur',
      text: 'Feeling less tired now',
      imageUrl: 'assets/profile_pics/person_ray.jpeg',
    ),
    Review(
      name: 'Alibek',
      text: 'Good for workouts ',
      imageUrl: 'assets/profile_pics/person_sandra.jpeg',
    ),
    Review(
      name: 'Madi',
      text: 'Nice vitamins, recommend',
      imageUrl: 'assets/profile_pics/person_stef.jpeg',
    ),
    Review(
      name: 'Sanzhar',
      text: 'Helps with focus',
      imageUrl: 'assets/profile_pics/person_tiffani.jpeg',
    ),
  ]
  ),
  Restaurants(
      '2',
      'Vitamin C',
      'Immunity Support',
      'Boosts immune system and helps fight infections',
      'assets/restaurants/vitaminc.jpg',
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80',
      1.1,
      4.9,
      [
        Item(
          name: 'Vitamin C 1000mg',
          description:
          '''High-strength formula that helps fight colds and supports immunity.''',
          price: 9.99,
          imageUrl: 'assets/restaurants/vitaminc1.jpg',
        ),
        Item(
          name: 'Vitamin C Gummies',
          description:
          '''Tasty chewable gummies for daily immune support.''',
          price: 11.49,
          imageUrl: 'assets/restaurants/vitaminc2.jpg',
        ),
        Item(
          name: 'Vitamin C + Zinc',
          description:
          '''Powerful combination to strengthen immunity and speed recovery.''',
          price: 12.99,
          imageUrl: 'assets/restaurants/vitaminc3.jpg',
        ),
        Item(
          name: 'Liquid Vitamin C',
          description:
          '''Fast-absorbing liquid formula for quick immune boost.''',
          price: 10.99,
          imageUrl: 'assets/restaurants/vitaminc4.jpg',
        ),
        Item(
          name: 'Organic Vitamin C Tablets',
          description:
          '''Natural source of vitamin C derived from organic fruits.''',
          price: 13.49,
          imageUrl: 'assets/restaurants/vitaminc5.jpg',
        ),
      ],[
    Review(
      name: 'Damir',
      text: 'Didn’t get sick this winter ',
      imageUrl: 'assets/profile_pics/person_cesare.jpeg',
    ),
    Review(
      name: 'Ilyas',
      text: 'Strong immunity boost',
      imageUrl: 'assets/profile_pics/person_crispy.png',
    ),
    Review(
      name: 'Zhandos',
      text: 'Good taste gummies',
      imageUrl: 'assets/profile_pics/person_joe.jpeg',
    ),
    Review(
      name: 'Erkebulan',
      text: 'Very useful ',
      imageUrl: 'assets/profile_pics/person_katz.jpeg',
    ),
    Review(
      name: 'Adil',
      text: 'Daily must-have vitamin',
      imageUrl: 'assets/profile_pics/person_kelvin.jpg',
    ),
  ]
  ),
  Restaurants(
      '3',
      'Vitamin D',
      'Bone Health',
      'Supports strong bones and improves calcium absorption',
      'assets/restaurants/vitamind.jpg',
      'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=800&q=80',
      1.3,
      4.8,
      [
        Item(
          name: 'Vitamin D3',
          description:
          '''Improves calcium absorption and supports bone strength.''',
          price: 12.99,
          imageUrl: 'assets/restaurants/vitamind1.jpg',
        ),
        Item(
          name: 'Vitamin D Softgels',
          description:
          '''Easy-to-swallow softgels for daily bone and immune support.''',
          price: 11.49,
          imageUrl: 'assets/restaurants/vitamind2.jpg',
        ),
        Item(
          name: 'Vitamin D + Calcium',
          description:
          '''Powerful combo to strengthen bones and teeth.''',
          price: 14.99,
          imageUrl: 'assets/restaurants/vitamind3.jpg',
        ),
        Item(
          name: 'Liquid Vitamin D',
          description:
          '''Fast-absorbing drops for better vitamin D intake.''',
          price: 10.99,
          imageUrl: 'assets/restaurants/vitamind4.jpg',
        ),
        Item(
          name: 'Vitamin D Gummies',
          description:
          '''Tasty chewable gummies for daily bone health.''',
          price: 13.49,
          imageUrl: 'assets/restaurants/vitamind5.jpg',
        ),
      ],[
    Review(
      name: 'Azamat',
      text: 'Bones feel stronger ',
      imageUrl: 'assets/profile_pics/person_manda.png',
    ),
    Review(
      name: 'Eldar',
      text: 'Good for winter, less fatigue',
      imageUrl: 'assets/profile_pics/person_ray.jpeg',
    ),
    Review(
      name: 'Serik',
      text: 'Doctor recommended, works well',
      imageUrl: 'assets/profile_pics/person_sandra.jpeg',
    ),
    Review(
      name: 'Zhasulan',
      text: 'Improved my energy levels',
      imageUrl: 'assets/profile_pics/person_stef.jpeg',
    ),
    Review(
      name: 'Kanat',
      text: 'Easy to take daily ',
      imageUrl: 'assets/profile_pics/person_tiffani.jpeg',
    ),
  ]
  ),
  Restaurants(
      '4',
      'Vitamin E',
      'Skin Health',
      'Supports healthy skin and protects cells from damage',
      'assets/restaurants/vitamine.jpg',
      'https://images.unsplash.com/photo-1584367369853-8d6a0c8c3c92?auto=format&fit=crop&w=800&q=80',
      0.9,
      4.7,
      [
        Item(
          name: 'Vitamin E Capsules',
          description:
          '''Protects skin cells, supports hydration, and slows aging.''',
          price: 11.99,
          imageUrl: 'assets/restaurants/vitamine1.jpg',
        ),
        Item(
          name: 'Vitamin E Oil',
          description:
          '''Nourishing oil for skin repair and deep hydration.''',
          price: 13.49,
          imageUrl: 'assets/restaurants/vitamine2.jpg',
        ),
        Item(
          name: 'Vitamin E Cream',
          description:
          '''Moisturizing cream that improves skin elasticity.''',
          price: 14.99,
          imageUrl: 'assets/restaurants/vitamine3.jpg',
        ),
        Item(
          name: 'Vitamin E + Collagen',
          description:
          '''Supports skin regeneration and reduces wrinkles.''',
          price: 16.49,
          imageUrl: 'assets/restaurants/vitamine4.jpg',
        ),
        Item(
          name: 'Vitamin E Gummies',
          description:
          '''Easy and tasty way to support healthy skin daily.''',
          price: 12.49,
          imageUrl: 'assets/restaurants/vitamine5.jpg',
        ),
      ],[
    Review(
      name: 'Daniyar',
      text: 'Skin looks much better ',
      imageUrl: 'assets/profile_pics/person_cesare.jpeg',
    ),
    Review(
      name: 'Aruzhan',
      text: 'Very good for dry skin',
      imageUrl: 'assets/profile_pics/person_crispy.png',
    ),
    Review(
      name: 'Malik',
      text: 'Noticed smoother skin after a week',
      imageUrl: 'assets/profile_pics/person_joe.jpeg',
    ),
    Review(
      name: 'Aigerim',
      text: 'Helps with skin recovery ',
      imageUrl: 'assets/profile_pics/person_katz.jpeg',
    ),
    Review(
      name: 'Yernur',
      text: 'Great vitamin for daily care',
      imageUrl: 'assets/profile_pics/person_kelvin.jpg',
    ),
  ]
  ),

];
