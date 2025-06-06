import React, { useMemo } from 'react';

const getCategoryColor = (category) => {
  const colors = {
    'Frutas y Verduras': 'bg-green-100 border-green-500',
    'Lácteos': 'bg-blue-100 border-blue-500',
    'Panadería': 'bg-yellow-100 border-yellow-500',
    'Carnes': 'bg-red-100 border-red-500',
    'Frágil': 'bg-purple-100 border-purple-500',
    'Congelados': 'bg-cyan-100 border-cyan-500',
    'Químicos': 'bg-amber-100 border-amber-500',
    'Limpieza': 'bg-teal-100 border-teal-500',
    'Pesado': 'bg-stone-100 border-stone-500',
    'Misceláneos': 'bg-gray-100 border-gray-500',
    'default': 'bg-gray-100 border-gray-500'
  };
  return colors[category] || colors.default;
};

const getCategoryHeaderColor = (category) => {
  const colors = {
    'Frutas y Verduras': 'bg-green-600 text-white',
    'Lácteos': 'bg-blue-600 text-white',
    'Panadería': 'bg-yellow-600 text-white',
    'Carnes': 'bg-red-600 text-white',
    'Frágil': 'bg-purple-600 text-white',
    'Congelados': 'bg-cyan-600 text-white',
    'Químicos': 'bg-amber-600 text-white',
    'Limpieza': 'bg-teal-600 text-white',
    'Pesado': 'bg-stone-600 text-white',
    'Misceláneos': 'bg-gray-600 text-white',
    'default': 'bg-gray-600 text-white'
  };
  return colors[category] || colors.default;
};

function ItemsByCategoryList({ items, setDraggedItem }) {
  const itemsByCategory = useMemo(() => {
    const groupedItems = {};
    
    items.forEach(item => {
      if (!groupedItems[item.category]) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category].push(item);
    });
    
    return groupedItems;
  }, [items]);

  const categories = useMemo(() => {
    return Object.keys(itemsByCategory).sort();
  }, [itemsByCategory]);

  return (
    <div className="bg-white rounded-xl shadow-lg p-6">
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-800">Artículos por Categoría</h2>
        <p className="text-sm text-gray-500 mt-1">Arrastra artículos a las bolsas para empacarlos</p>
      </div>
      
      <div className="space-y-4">
        {categories.length > 0 ? (
          categories.map(category => (
            <div key={category} className="overflow-hidden rounded-lg border border-gray-200">
              <div className={`p-3 ${getCategoryHeaderColor(category)}`}>
                <h3 className="font-medium">{category}</h3>
              </div>
              <div className="p-3 grid grid-cols-1 sm:grid-cols-2 gap-3">
                {itemsByCategory[category].map((item) => (
                  <div
                    key={item.id}
                    className={`p-3 rounded-lg border-2 transition-all transform hover:scale-105 cursor-pointer
                      ${getCategoryColor(category)}`}
                    draggable
                    onDragStart={() => setDraggedItem(item.id)}
                  >
                    <div className="font-semibold text-gray-800">{item.name}</div>
                    <div className="text-sm text-gray-600 mt-1">
                      {item.weight} kg
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))
        ) : (
          <div className="text-center py-8 text-gray-400">
            No hay artículos disponibles.
          </div>
        )}
      </div>
    </div>
  );
}

export default ItemsByCategoryList;