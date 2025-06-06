import React from 'react';
import { PlusIcon, XMarkIcon } from '@heroicons/react/24/outline';

function BagList({ bags, addNewBag, draggedItem, addItemToBag, removeItemFromBag }) {
  const handleDrop = (bagId) => {
    if (draggedItem) {
      addItemToBag(draggedItem, bagId);
    }
  };

  const handleDragOver = (e) => {
    e.preventDefault();
  };

  return (
    <div className="bg-white rounded-xl shadow-lg p-6">
      <div className="mb-6 flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold text-gray-800">Bolsas</h2>
          <p className="text-sm text-gray-500 mt-1">Suelta artículos aquí para empacarlos</p>
        </div>
        <button
          onClick={addNewBag}
          className="flex items-center px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
        >
          <PlusIcon className="h-5 w-5 mr-2" />
          Nueva Bolsa
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {bags.map((bag) => (
          <div
            key={bag.id}
            className="border-2 border-dashed border-gray-300 rounded-lg p-4 hover:border-indigo-500 transition-colors"
            onDrop={() => handleDrop(bag.id)}
            onDragOver={handleDragOver}
          >
            <div className="mb-2 flex justify-between items-center">
              <h3 className="font-semibold text-gray-700">Bolsa #{bag.id}</h3>
              <span className="text-sm text-gray-500">
                {bag.totalWeight.toFixed(1)} / 5.0 kg
              </span>
            </div>
            
            {bag.items && bag.items.length > 0 ? (
              <div className="space-y-2">
                {bag.items.map((item, index) => (
                  <div
                    key={index}
                    className="bg-gray-50 rounded p-2 text-sm flex justify-between items-center"
                  >
                    <div>
                      <div className="font-medium">{item.name}</div>
                      <div className="text-gray-500 text-xs">
                        {item.category} - {item.weight} kg
                      </div>
                    </div>
                    <button
                      onClick={() => removeItemFromBag(bag.id, index)}
                      className="text-red-500 hover:text-red-700 p-1"
                    >
                      <XMarkIcon className="h-5 w-5" />
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-400">
                Bolsa vacía
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

export default BagList;